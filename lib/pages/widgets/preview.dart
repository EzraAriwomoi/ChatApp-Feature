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
            top: 55,
            left: 12,
            child: CircleAvatar(
              radius: 21,
              backgroundColor: const Color.fromARGB(135, 24, 30, 39),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          //HD
          Positioned(
            top: 54,
            right: 205,
            child: CircleAvatar(
              radius: 21,
              backgroundColor: const Color.fromARGB(135, 24, 30, 39),
              child: IconButton(
                icon: const Icon(
                  Icons.hd_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  //hd logic
                },
              ),
            ),
          ),
          //rotate image
          Positioned(
            top: 54,
            right: 157,
            child: CircleAvatar(
              radius: 21,
              backgroundColor: const Color.fromARGB(135, 24, 30, 39),
              child: IconButton(
                icon: const Icon(
                  Icons.crop_rotate_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  //rotate logic
                },
              ),
            ),
          ),
          //stickers
          Positioned(
            top: 54,
            right: 109,
            child: CircleAvatar(
              radius: 21,
              backgroundColor: const Color.fromARGB(135, 24, 30, 39),
              child: IconButton(
                icon: const Icon(
                  Icons.sticky_note_2_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  //sticker logic
                },
              ),
            ),
          ),
          //text
          Positioned(
            top: 54,
            right: 61,
            child: CircleAvatar(
              radius: 21,
              backgroundColor: const Color.fromARGB(135, 24, 30, 39),
              child: IconButton(
                icon: const Icon(
                  Icons.text_fields_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  //text logic
                },
              ),
            ),
          ),
          //edit
          Positioned(
            top: 54,
            right: 12,
            child: CircleAvatar(
              radius: 21,
              backgroundColor: const Color.fromARGB(135, 24, 30, 39),
              child: IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 24,
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
              color: const Color.fromARGB(255, 9, 15, 19),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 16, 26, 32),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
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
                    radius: 24,
                    backgroundColor: Coloors.greenDark,
                    child: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
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
