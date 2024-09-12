import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.black,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          maxChildSize: 0.5,
          minChildSize: 0.3,
          builder: (_, controller) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    controller: controller,
                    children: [
                      // GIF
                      Center(
                        child: Image.asset(
                          'assets/your_gif.gif', // Replace with your GIF asset path
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Header Text
                      Center(
                        child: Text(
                          'Your chat and calls are private',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Small descriptive text
                      Center(
                        child: Text(
                          'This keeps your account safe and secure. This includes your:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Message Icon and Text
                      Row(
                        children: [
                          Icon(Icons.message, color: Colors.grey),
                          SizedBox(width: 10),
                          Text(
                            'Text and voice messages',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Call Icon and Text
                      Row(
                        children: [
                          Icon(Icons.call, color: Colors.grey),
                          SizedBox(width: 10),
                          Text(
                            'Audio and video call',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      // Location Icon and Text
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.grey),
                          SizedBox(width: 10),
                          Text(
                            'Location sharing',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
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
                            minimumSize: Size(double.infinity, 50), // Full width button
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25), // Curved corners
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
}