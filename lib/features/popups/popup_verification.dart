import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';

class PopupVerification {
  static void showVerificationPopup(BuildContext context) {
    final TextEditingController texteditingcontroller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 36),
                    child: Text(
                      'Enter your two-step verification PIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Arial',
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // TextField
                      Center(
                        child: SizedBox(
                          width: 165,
                          child: TextField(
                            controller: texteditingcontroller,
                            textAlign: TextAlign.center,
                            obscureText: true,
                            obscuringCharacter: '*',
                            style: const TextStyle(
                              fontSize: 22,
                              letterSpacing: 3,
                            ),
                            cursorColor: Colors.green,
                            cursorHeight: 23,
                            decoration: InputDecoration(
                              hintText: _getHintText(texteditingcontroller),
                              hintStyle: TextStyle(
                                fontSize: 22,
                                color: context.theme.greyColor,
                                letterSpacing: 3,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0,
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(top: 4, bottom: 0),
                              isDense: true,
                              counterText: '',
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'You will be asked for it periodically to help you\nremember it. ',
                                style: TextStyle(
                                  color: context.theme.greyColor,
                                  fontSize: 13.5,
                                  fontFamily: 'Arial',
                                  letterSpacing: 0,
                                ),
                              ),
                              TextSpan(
                                text: 'Forgot PIN?',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 13.5,
                                  fontFamily: 'Arial',
                                  letterSpacing: 0,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showTurnOffPopup(context);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // Clear the controller when the dialog is closed
      texteditingcontroller.clear();
    });
  }

  static void showTurnOffPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        content: SingleChildScrollView( 
          child: SizedBox(
            width: 550,
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 0),
                    child: Text(
                      'Turn off two-step verification?',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Arial',
                        color: context.theme.greyColor,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Cancel Button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontFamily: 'Arial',
                            letterSpacing: 0,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),
                      
                      // Turn Off Button
                      TextButton(
                        onPressed: () {
                          //logic here
                        },
                        child: const Text(
                          'Turn off',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontFamily: 'Arial',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  // Function to generate hint text based on current input length
  static String _getHintText(TextEditingController controller) {
    final String currentInput = controller.text;
    final int length = currentInput.length;
    const String hint = '* * *   * * *';
    return hint.replaceRange(0, length, ' ' * length);
  }
}
