// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/models/current_user_provider.dart';
import 'package:ult_whatsapp/common/models/user_model.dart';
import 'package:ult_whatsapp/common/routes/routes.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/common/widgets/custom_icon_button.dart';
import 'package:ult_whatsapp/features/contact/contact_card.dart';
import 'package:ult_whatsapp/features/contact/contacts_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class NoStretchScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

final newContactsLoadingProvider = StateProvider<bool>((ref) => false);

class ContactPage extends ConsumerStatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends ConsumerState<ContactPage> {
  Timer? _timer;
  List<UserModel> _previousFirebaseContacts = [];
  List<UserModel> _previousPhoneContacts = [];

  @override
  void initState() {
    super.initState();
    _startContactCheck();
  }

  void _startContactCheck() {
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      final contactsAsyncValue = ref.watch(contactsControllerProvider);
      if (contactsAsyncValue is AsyncData<List<List<UserModel>>>) {
        final allContacts = contactsAsyncValue.value;
        final firebaseContacts = allContacts[0];
        final phoneContacts = allContacts[1];

        bool newContactsInFirebase =
            !_areContactsEqual(firebaseContacts, _previousFirebaseContacts);
        bool newContactsInPhonebook =
            !_areContactsEqual(phoneContacts, _previousPhoneContacts);

        if (newContactsInFirebase || newContactsInPhonebook) {
          ref.read(newContactsLoadingProvider.notifier).state = true;
          Future.delayed(const Duration(seconds: 1), () {
            ref.read(newContactsLoadingProvider.notifier).state = false;
          });

          // Update previous contacts
          _previousFirebaseContacts = firebaseContacts;
          _previousPhoneContacts = phoneContacts;
        }
      }
    });
  }

  bool _areContactsEqual(List<UserModel> list1, List<UserModel> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].uid != list2[i].uid) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> shareSmsLink(String phoneNumber) async {
    final Uri sms = Uri.parse(
      "sms:$phoneNumber?body=Let's chat on WhatsApp! It's a fast, simple, and secure app we can use to message and call each other for free. Get it at https://whatsapp.com/dl/",
    );
    if (await launchUrl(sms)) {
      // Successfully launched SMS
    } else {
      // Failed to launch SMS
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactsAsyncValue = ref.watch(contactsControllerProvider);
    final currentUserAsyncValue = ref.watch(currentUserProvider);
    final isNewContactsLoading = ref.watch(newContactsLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.barcolor,
        elevation: 0,
        leading: BackButton(color: context.theme.baricons),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select contact',
              style: TextStyle(
                fontSize: 17,
                color: context.theme.baricons,
              ),
            ),
            const SizedBox(height: 0),
            contactsAsyncValue.when(
              data: (allContacts) {
                return Text(
                  "${allContacts[0].length} contact${allContacts[0].length == 1 ? '' : 's'}",
                  style: TextStyle(fontSize: 12, color: context.theme.baricons),
                );
              },
              loading: () => Text(
                'loading...',
                style: TextStyle(fontSize: 12, color: context.theme.baricons),
              ),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
        actions: [
          if (isNewContactsLoading)
            Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: context.theme.baricons,
                  strokeWidth: 2.0,
                ),
              ),
            ),
          CustomIconButton(
              onPressed: () {},
              icon: Icons.search,
              iconColor: context.theme.baricons),
          CustomIconButton(
              onPressed: () {},
              icon: Icons.more_vert,
              iconColor: context.theme.baricons),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: context.theme.line,
            height: 0.2,
          ),
        ),
      ),
      body: contactsAsyncValue.when(
        data: (allContacts) {
          List<UserModel> firebaseContacts = allContacts[0];
          List<UserModel> phoneContacts = allContacts[1];

          return currentUserAsyncValue.when(
            data: (currentUser) {
              return ScrollConfiguration(
                behavior: NoStretchScrollBehavior(),
                child: ListView.builder(
                  itemCount: firebaseContacts.length +
                      phoneContacts.length +
                      3, // +3 for the header, current user, and "Invite to WhatsApp" text
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            myListTile(
                              leading: Icons.group_add_rounded,
                              text: 'New group',
                            ),
                            myListTile(
                              leading: Icons.person_add_alt_1_rounded,
                              text: 'New contact',
                              trailing: Icons.qr_code,
                            ),
                            myListTile(
                              leading: Icons.groups_2_rounded,
                              text: 'New community',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Text(
                                'Contacts on WhatsApp',
                                style: TextStyle(
                                  color: context.theme.greyColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ]);
                    } else if (index == 1) {
                      // Display the current user
                      return ContactCard(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.chat,
                            arguments: currentUser,
                          );
                        },
                        contactSource: UserModel(
                          username: '${currentUser.username} (You)',
                          uid: currentUser.uid,
                          profileImageUrl: currentUser.profileImageUrl,
                          active: currentUser.active,
                          lastSeen: currentUser.lastSeen,
                          phoneNumber: currentUser.phoneNumber,
                          groupId: currentUser.groupId,
                        ),
                        isCurrentUser: true,
                      );
                    } else if (index <= firebaseContacts.length + 1) {
                      final UserModel contact = firebaseContacts[index - 2];
                      return ContactCard(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.chat,
                            arguments: contact,
                          );
                        },
                        contactSource: contact,
                      );
                    } else if (index == firebaseContacts.length + 2) {
                      // Display "Invite to WhatsApp" text
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          'Invite to WhatsApp',
                          style: TextStyle(
                            color: context.theme.greyColor,
                            fontSize: 12,
                          ),
                        ),
                      );
                    } else {
                      final UserModel contact =
                          phoneContacts[index - firebaseContacts.length - 3];
                      return ContactCard(
                        contactSource: contact,
                        onTap: () => shareSmsLink(contact.phoneNumber),
                      );
                    }
                  },
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: Coloors.greenDark,
              ),
            ),
            error: (_, __) => const SizedBox(),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Coloors.greenDark,
          ),
        ),
        error: (_, __) => const SizedBox(),
      ),
    );
  }

  ListTile myListTile({
    required IconData leading,
    required String text,
    IconData? trailing,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.only(top: 10, left: 20, right: 10),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Coloors.greenDark,
        child: Icon(
          leading,
          color: Colors.white,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing != null
          ? Padding(
              padding: const EdgeInsets.only(
                  right: 50.0),
              child: Icon(
                trailing,
                color: context.theme.baricons,
              ),
            )
          : null,
    );
  }
}
