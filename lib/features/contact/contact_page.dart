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

class ContactPage extends ConsumerWidget {
  const ContactPage({super.key});

  Future<void> shareSmsLink(String phoneNumber) async {
    final Uri sms = Uri.parse(
      "sms:$phoneNumber?body=Let's chat on WhatsApp! It's a fast, simple, and secure app we can use to message and call each other for free. Get it at https://whatsapp.com/dl/",
    );
    if (await launchUrl(sms)) {
    } else {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<List<UserModel>>> contactsAsyncValue =
        ref.watch(contactsControllerProvider);

    final currentUserAsyncValue = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select contact',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 0),
            contactsAsyncValue.when(
              data: (allContacts) {
                return Text(
                  "${allContacts[0].length} contact${allContacts[0].length == 1 ? '' : 's'}",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                );
              },
              loading: () => const Text(
                'loading...',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              error: (error, stackTrace) => const SizedBox(),
            ),
          ],
        ),
        actions: [
          CustomIconButton(
              onPressed: () {}, icon: Icons.search, iconColor: Colors.white),
          CustomIconButton(
              onPressed: () {}, icon: Icons.more_vert, iconColor: Colors.white),
        ],
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
                                  fontWeight: FontWeight.w600,
                                  color: context.theme.greyColor,
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
                            fontWeight: FontWeight.w600,
                            color: context.theme.greyColor,
                            fontSize: 14,
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
            error: (error, stackTrace) => Center(
              child: Text('Error: $error'),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Coloors.greenDark,
          ),
        ),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
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
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: trailing != null
          ? Icon(
              trailing,
              color: Coloors.greyDark,
            )
          : null,
    );
  }
}
