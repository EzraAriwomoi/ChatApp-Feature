import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/common/widgets/custom_icon_button.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({
    super.key,
    required this.path,
    required this.turnFlashOn,
  });

  final String path;
  final bool turnFlashOn;

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.turnFlashOn);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned(
              top: 37,
              left: 0,
              right: 0,
              bottom: 108,
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Image.file(
                  File(widget.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Close button
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
            // HD button
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
                    // HD logic here
                  },
                ),
              ),
            ),
            // Rotate image
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
                    // Rotate logic here
                  },
                ),
              ),
            ),
            // Sticker button
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
                    // Sticker logic here
                  },
                ),
              ),
            ),
            // Text button
            Positioned(
              top: 54,
              right: 61,
              child: CircleAvatar(
                radius: 21,
                backgroundColor: const Color.fromARGB(135, 24, 30, 39),
                child: IconButton(
                  icon: const Icon(
                    Icons.title_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  onPressed: () {
                    // Text logic here
                  },
                ),
              ),
            ),
            // Edit button
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
                    // Editing logic here
                  },
                ),
              ),
            ),
            // Caption input field
            Positioned(
              bottom: 0,
              left: 3,
              right: 4,
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
                          suffixIcon: Material(
                            color: Colors.transparent,
                            child: CustomIconButton(
                              onPressed: () {},
                              icon: Icons.motion_photos_on_rounded,
                              iconColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 11),
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Coloors.greenDark,
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
