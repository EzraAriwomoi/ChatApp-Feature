import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import '../../popups/end_to_end_encrypted.dart';

class YellowCard extends StatelessWidget {
  const YellowCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showEndToEndBottomSheet(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
        decoration: BoxDecoration(
          color: context.theme.yellowCardBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 10,
                  color: context.theme.yellowCardTextColor,
                ),
                alignment: PlaceholderAlignment.middle,
              ),
              TextSpan(
                text:
                    ' Messages and calls are end-to-end encrypted. No one outside of this\nchat, not even WhatsApp, can read or listen to them. Tap to learn more.',
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'Arial',
                  color: context.theme.yellowCardTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
