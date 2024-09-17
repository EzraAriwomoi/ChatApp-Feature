import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/common/widgets/custom_icon_button.dart';

class PreviewPage extends StatelessWidget {
  final Uint8List media;
  final bool isVideo;
  final String username;

  const PreviewPage({
    super.key,
    required this.media,
    required this.username,
    this.isVideo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: isVideo
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black,
                    child: const Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                      size: 64,
                    ),
                  )
                : Image.memory(
                    media,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  //editing logic
                },
              ),
            ),
          ),
          Positioned(
            bottom: 66,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines: 4,
                      minLines: 1,
                      onChanged: (value) {},
                      cursorColor: Coloors.greenDark,
                      cursorHeight: 18,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Arial',
                        fontSize: 17,
                        letterSpacing: 0,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add a caption...',
                        hintStyle: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Arial',
                          fontSize: 17,
                          letterSpacing: 0,
                        ),
                        filled: true,
                        fillColor: Coloors.backgroundDark,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            style: BorderStyle.none,
                            width: 0,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Material(
                          color: Colors.transparent,
                          child: CustomIconButton(
                            onPressed: () {},
                            icon: Icons.add_photo_alternate_outlined,
                            iconColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Coloors.backgroundDark,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 21, 32, 39),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Arial',
                              letterSpacing: 0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Coloors.greenDark,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.black),
                      onPressed: () {
                        // send logic
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
