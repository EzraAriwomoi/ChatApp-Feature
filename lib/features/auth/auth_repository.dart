// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/models/user_model.dart';
import 'package:ult_whatsapp/common/repository/firebase_storage_repo.dart';
import '../../common/helper/show_alert_dialog.dart';
import '../../common/helper/show_loading_dialog.dart';
import '../../common/routes/routes.dart';

final authRepositoryProvider = Provider((ref) {
  return AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    realtime: FirebaseDatabase.instance,
  );
});

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final FirebaseDatabase realtime;

  AuthRepository({
    required this.auth,
    required this.firestore,
    required this.realtime,
  }) {
    updateUserPresence();
  }

  Stream<UserModel> getUserPresenceStatus({required String uid}) {
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  // Presence feature
  void updateUserPresence() {
    final connectedRef = realtime.ref('.info/connected');

    connectedRef.onValue.listen((event) async {
      final isConnected = event.snapshot.value as bool? ?? false;
      if (isConnected) {
        // Update Firestore document with the online status
        await updateActiveStatus(true);
      } else {
        // Ensure offline status is set when disconnected
        await updateActiveStatus(false);
      }
    });

    WidgetsBinding.instance.addObserver(LifecycleObserver(
      onResume: () {
        updateActiveStatus(true);
      },
      onPause: () {
        updateActiveStatus(false);
      },
    ));
  }

  Future<void> updateActiveStatus(bool isOnline) async {
    final user = auth.currentUser;
    if (user == null) return;

    final userStatusDatabaseRef = realtime.ref('status/${user.uid}');
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // This ensures that when the user disconnects, their status is automatically set to offline
    await userStatusDatabaseRef.onDisconnect().set({
      'is_online': false,
      'lastSeen': DateTime.now().millisecondsSinceEpoch,
    });

    await firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'lastSeen': timestamp,
    });

    await userStatusDatabaseRef.set({
      'is_online': isOnline,
      'lastSeen': timestamp,
    });
  }

  Future<UserModel?> getCurrentUserInfo() async {
    final userInfo =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    if (userInfo.data() == null) return null;
    return UserModel.fromMap(userInfo.data()!);
  }

  void saveUserInfoToFirestore({
    required String username,
    required var profileImage,
    required ProviderRef ref,
    required BuildContext context,
    required bool mounted,
  }) async {
    try {
      showLoadingDialog(
        context: context,
        message: "Saving user info ... ",
      );

      String uid = auth.currentUser!.uid;
      String profileImageUrl = profileImage is String ? profileImage : '';

      if (profileImage != null && profileImage is! String) {
        profileImageUrl = await ref
            .read(firebaseStorageRepositoryProvider)
            .storeFileToFirebase('profileImage/$uid', profileImage);
      }

      UserModel user = UserModel(
        username: username,
        uid: uid,
        profileImageUrl: profileImageUrl,
        active: true,
        lastSeen: DateTime.now().millisecondsSinceEpoch,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );

      await firestore.collection('users').doc(uid).set(user.toMap());

      if (!mounted) return; // Avoid using context if the widget is unmounted

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.home,
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showAlertDialog(context: context, message: e.toString());
      }
    }
  }

  void verifySmsCode({
    required BuildContext context,
    required String smsCodeId,
    required String smsCode,
    required bool mounted,
  }) async {
    try {
      showLoadingDialog(
        context: context,
        message: 'Verifying code... ',
      );
      final credential = PhoneAuthProvider.credential(
        verificationId: smsCodeId,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
      UserModel? user = await getCurrentUserInfo();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.userInfo,
        (route) => false,
        arguments: user?.profileImageUrl,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showAlertDialog(context: context, message: e.toString());
    }
  }

  void sendSmsCode({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      showLoadingDialog(
        context: context,
        message: "Sending a verification code to $phoneNumber",
      );
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          Navigator.pop(context);
          showAlertDialog(context: context, message: e.toString());
        },
        codeSent: (smsCodeId, resendSmsCodeId) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.verification,
            (route) => false,
            arguments: {
              'phoneNumber': phoneNumber,
              'smsCodeId': smsCodeId,
            },
          );
        },
        codeAutoRetrievalTimeout: (String smsCodeId) {},
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showAlertDialog(context: context, message: e.toString());
    }
  }
}

class LifecycleObserver extends WidgetsBindingObserver {
  final VoidCallback onResume;
  final VoidCallback onPause;

  LifecycleObserver({
    required this.onResume,
    required this.onPause,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    } else if (state == AppLifecycleState.paused) {
      onPause();
    }
  }
}
