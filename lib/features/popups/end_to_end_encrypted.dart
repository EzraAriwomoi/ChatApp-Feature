import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';

void showEndToEndBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    backgroundColor: context.theme.barcolor,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.53,
        maxChildSize: 0.53,
        minChildSize: 0.3,
        builder: (_, controller) {
          return Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 195),
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: context.theme.greyColor!.withOpacity(.8),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ScrollConfiguration(
                  behavior: NoStretchScrollBehavior(),
                  child: ListView(
                    controller: controller,
                    children: [
                      // GIF
                      Center(
                        child: Image.asset(
                          'assets/encryption.gif',
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Center(
                        child: Text(
                          'Your chats and calls are private',
                          style: TextStyle(
                            color: context.theme.baricons,
                            fontSize: 20,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),

                      Center(
                        child: Text(
                          'End to end encryption keeps your personal messages and calls \nbetween you and the people you choose. Not even WhatApp can \nread or listen to them. This includes your:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.theme.greyColor,
                            fontSize: 14,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Messages
                      Row(
                        children: [
                          Icon(
                            Icons.message,
                            size: 16,
                            color: context.theme.greyColor,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Text and voice messages',
                            style: TextStyle(
                              color: context.theme.greyColor,
                              fontSize: 15,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Call Icon and Text
                      Row(
                        children: [
                          Icon(
                            Icons.call_end_outlined,
                            size: 16,
                            color: context.theme.greyColor,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Audio and video calls',
                            style: TextStyle(
                              color: context.theme.greyColor,
                              fontSize: 15,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Photos, videos and doc
                      Row(
                        children: [
                          Icon(
                            Icons.link_outlined,
                            size: 16,
                            color: context.theme.greyColor,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Photos, videos and documents',
                            style: TextStyle(
                              color: context.theme.greyColor,
                              fontSize: 15,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Location Icon and Text
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: context.theme.greyColor,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Location sharing',
                            style: TextStyle(
                              color: context.theme.greyColor,
                              fontSize: 15,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Status update
                      Row(
                        children: [
                          Icon(
                            Icons.motion_photos_on_rounded,
                            size: 16,
                            color: context.theme.greyColor,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Status updates',
                            style: TextStyle(
                              color: context.theme.greyColor,
                              fontSize: 15,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),

                      // Learn More Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            const url = 'https://www.whatsapp.com/security';
                            final Uri uri = Uri.parse(url);

                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            minimumSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Learn more',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Arial',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Close button
              Positioned(
                left: 20,
                top: 40,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

class NoStretchScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Removes the stretching effect
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(); // Removes the iOS-style bouncing effect
  }
}
