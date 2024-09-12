import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';

void showEndToEndBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
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
                padding: const EdgeInsets.all(30.0),
                child: ListView(
                  controller: controller,
                  children: [
                    // GIF
                    Center(
                      child: Image.asset(
                        'assets/encryption.gif', // Add your gif in assets
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // Header Text
                    Center(
                      child: Text(
                        'Your chats and calls are private',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                    SizedBox(height: 15),

                    // Small descriptive text
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
                    SizedBox(height: 20),

                    // Message Icon and Text
                    Row(
                      children: [
                        Icon(
                          Icons.message,
                          size: 16,
                          color: context.theme.greyColor,
                        ),
                        SizedBox(width: 20),
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
                    SizedBox(height: 10),

                    // Call Icon and Text
                    Row(
                      children: [
                        Icon(
                          Icons.call_end_outlined,
                          size: 16,
                          color: context.theme.greyColor,
                        ),
                        SizedBox(width: 20),
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
                    SizedBox(height: 10),

                    // Photos, videos and doc
                    Row(
                      children: [
                        Icon(
                          Icons.call_end_outlined,
                          size: 16,
                          color: context.theme.greyColor,
                        ),
                        SizedBox(width: 20),
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
                    SizedBox(height: 10),

                    // Location Icon and Text
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: context.theme.greyColor,
                        ),
                        SizedBox(width: 20),
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
                    SizedBox(height: 30),

                    // Learn More Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Action for Learn More button
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize:
                              Size(double.infinity, 50), // Full width button
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25), // Curved corners
                          ),
                        ),
                        child: Text(
                          'Learn more',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Close button
              Positioned(
                right: 20,
                top: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
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
