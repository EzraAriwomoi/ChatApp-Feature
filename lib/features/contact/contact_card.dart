import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/models/user_model.dart';
import '../../../common/utils/coloors.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.contactSource,
    required this.onTap,
    this.isCurrentUser = false,
  });

  final UserModel contactSource;
  final VoidCallback onTap;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(
        left: 20,
        right: 10,
      ),
      leading: CircleAvatar(
        backgroundColor: context.theme.greyColor,
        radius: 20,
        backgroundImage: contactSource.profileImageUrl.isNotEmpty
            ? CachedNetworkImageProvider(contactSource.profileImageUrl)
            : null,
        child: contactSource.profileImageUrl.isEmpty
            ? const Icon(
                Icons.person_rounded,
                size: 40,
                color: Colors.white,
              )
            : null,
      ),
      title: Text(
        contactSource.username,
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
      subtitle: isCurrentUser
          ? Text(
              "Message yourself",
              style: TextStyle(
                color: context.theme.greyColor,
                fontSize: 12,
              ),
            )
          : contactSource.uid.isNotEmpty
              ? Text(
                  "Hey there! I'm using WhatsApp",
                  style: TextStyle(
                    color: context.theme.greyColor,
                    fontSize: 12,
                  ),
                )
              : null,
      trailing: contactSource.uid.isEmpty
          ? TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                foregroundColor: Coloors.greenLight,
              ),
              child: const Text('Invite',style: TextStyle(fontSize: 12,letterSpacing: 1),),
            )
          : null,
    );
  }
}
