import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';

class PrivacyAndTerms extends StatelessWidget {
  const PrivacyAndTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 52, vertical: 10),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'Read our ',
            style: TextStyle(
              color: context.theme.greyColor,
              fontSize: 12,
              letterSpacing: 0,
              height: 1.5
            ),
            children: [
              TextSpan(
                text: 'Privacy Policy. ',
                style: TextStyle(
                  color: context.theme.blueColor,
                  letterSpacing: 0,
                ),
              ),
              const TextSpan(text: 'Tap "Agree and continue" to accept the '),
              TextSpan(
                text: 'Terms of Service.',
                style: TextStyle(
                  color: context.theme.blueColor,
                  letterSpacing: 0,
                ),
              ),
            ]),
      ),
    );
  }
}
