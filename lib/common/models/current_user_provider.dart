import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

final currentUserProvider = FutureProvider<UserModel>((ref) async {
  return await fetchCurrentUser();
});

Future<UserModel> fetchCurrentUser() async {
  try {
    // Get the current user's UID
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception('No user is currently signed in.');
    }

    // Fetch the user document from Firestore
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // If the user document exists, return a UserModel
    if (userDoc.exists) {
      return UserModel.fromMap(userDoc.data()!);
    } else {
      throw Exception('User not found');
    }
  } catch (e) {
    throw Exception('Failed to fetch user: $e');
  }
}
