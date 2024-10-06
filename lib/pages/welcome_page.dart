import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/routes/routes.dart';
import 'package:ult_whatsapp/common/widgets/custom_elevated_buttom.dart';
import 'package:ult_whatsapp/features/language_button_show.dart';
import 'package:ult_whatsapp/features/widget/privacy_and_terms.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  navigateToLoginPage(context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const SizedBox(height: 25),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 56,
                vertical: 0,
              ),
              child: Image.asset(
                'assets/circle.png',
                color: context.theme.circleImageColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: Column(children: [
            const Text(
              'Welcome to UltWhatsApp',
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'Arial',
                letterSpacing: 0,
              ),
            ),
            const PrivacyAndTerms(),
            const SizedBox(height: 10),
            const LanguageButton(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
              ),
              child: CustomElevatedButton(
                onPressed: () => navigateToLoginPage(context),
                text: 'Agree and continue',
              ),
            ),
          ]),
        ),
      ]),
    );
  }
}
