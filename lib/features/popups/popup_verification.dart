import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';

class PopupVerification {
  static void showVerificationPopup(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 36),
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
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // TextField
                      Center(
                        child: SizedBox(
                          width: 165, // Adjust width to reduce size
                          child: TextField(
                            controller: _controller,
                            textAlign: TextAlign.center,
                            obscureText: true,
                            obscuringCharacter: '*',
                            style: const TextStyle(
                              fontSize: 22, // Adjust font size to fit better
                              letterSpacing: 3,
                            ),
                            cursorColor: Colors.green,
                            cursorHeight: 23,
                            decoration: InputDecoration(
                              hintText: _getHintText(_controller),
                              hintStyle: TextStyle(
                                fontSize: 22,
                                color: context.theme.greyColor,
                                letterSpacing: 3,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0, // Adjust underline thickness
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                  width: 2.0, // Adjust underline thickness
                                ),
                              ),
                              contentPadding: EdgeInsets.only(top: 4, bottom: 0), // Adjust padding to reduce gap
                              isDense: true,
                              counterText: '', // Removes 0/6 counter
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Text below TextField
                      Padding(
                        padding: EdgeInsets.only(left: 0),
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
                                style: TextStyle(
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
      _controller.clear();
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
              padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0), // Remove unnecessary padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  // Message
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
                  SizedBox(height: 16),
                  
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Cancel Button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontFamily: 'Arial',
                            letterSpacing: 0,
                          ),
                        ),
                      ),
                      SizedBox(width: 10), // Spacer between buttons
                      
                      // Turn Off Button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text(
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
    final String hint = '* * *   * * *';

    // Replace asterisks with spaces based on input length
    return hint.replaceRange(0, length, ' ' * length);
  }
}
