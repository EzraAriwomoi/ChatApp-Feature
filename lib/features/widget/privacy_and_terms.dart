import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyAndTerms extends StatelessWidget {
  const PrivacyAndTerms({super.key});

  Future<void> _launchPrivacyPolicyURL() async {
    const privacyUrl =
        'https://www.whatsapp.com/legal/privacy-policy?lg=en&lc=US';
    if (await canLaunchUrl(Uri.parse(privacyUrl))) {
      await launchUrl(Uri.parse(privacyUrl));
    } else {
      throw 'Could not launch $privacyUrl';
    }
  }

  Future<void> _launchTermsOfServiceURL() async {
    const termsUrl =
        'https://www.whatsapp.com/legal/terms-of-service?lg=en&lc=US';
    if (await canLaunchUrl(Uri.parse(termsUrl))) {
      await launchUrl(Uri.parse(termsUrl));
    } else {
      throw 'Could not launch $termsUrl';
    }
  }

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
                height: 1.5),
            children: [
              TextSpan(
                text: 'Privacy Policy. ',
                style: TextStyle(
                  color: context.theme.blueColor,
                  letterSpacing: 0,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = _launchPrivacyPolicyURL,
              ),
              const TextSpan(text: 'Tap "Agree and continue" to accept the '),
              TextSpan(
                text: 'Terms of Service.',
                style: TextStyle(
                  color: context.theme.blueColor,
                  letterSpacing: 0,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = _launchTermsOfServiceURL,
              ),
            ]),
      ),
    );
  }
}
