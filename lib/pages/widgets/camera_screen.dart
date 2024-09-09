import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  final CameraController? cameraController;
  const CameraScreen({super.key, this.cameraController});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  FlashMode _flashMode = FlashMode.off;
  bool isRecording = false;
  bool isVideoMode = false;

  // Flash mode toggle function
  void _toggleFlash() {
    setState(() {
      // Cycle through the 3 modes: off -> on -> auto -> off...
      if (_flashMode == FlashMode.off) {
        _flashMode = FlashMode.torch;
      } else if (_flashMode == FlashMode.torch) {
        _flashMode = FlashMode.auto;
      } else {
        _flashMode = FlashMode.off;
      }
    });

    widget.cameraController?.setFlashMode(_flashMode);
  }

  void _captureOrRecord() async {
    if (isVideoMode) {
      if (isRecording) {
        await widget.cameraController?.stopVideoRecording();
      } else {
        await widget.cameraController?.startVideoRecording();
      }
      setState(() {
        isRecording = !isRecording;
      });
    } else {
      await widget.cameraController?.takePicture();
    }
  }

  // Switch to Photo Mode
  void _switchToPhotoMode() {
    setState(() {
      isVideoMode = false;
    });
  }

  // Switch to Video Mode
  void _switchToVideoMode() {
    setState(() {
      isVideoMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(
            child: widget.cameraController != null
                ? CameraPreview(widget.cameraController!)
                : Container(
                    color: Colors.black,
                  ),
          ),

          SafeArea(
            child: Stack(
              children: [
                // Close button
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 13, 21, 26)
                          .withOpacity(0.4),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),

                // Flashlight toggle
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: _toggleFlash,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(255, 13, 21, 26)
                            .withOpacity(0.4),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 100),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.0, -1.0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          );
                        },
                        child: Icon(
                          key: ValueKey(_flashMode),
                          _flashMode == FlashMode.off
                              ? Icons.flash_off_rounded
                              : _flashMode == FlashMode.torch
                                  ? Icons.flash_on_rounded
                                  : Icons.flash_auto_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),

                // Capture button
                Positioned(
                  bottom: 125,
                  left: MediaQuery.of(context).size.width * 0.5 - 35,
                  child: GestureDetector(
                    onTap: !isVideoMode ? _captureOrRecord : null,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer border
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Mode switch buttons
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black,
                    height: 110,
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          left: isVideoMode
                              ? MediaQuery.of(context).size.width * 0.42
                              : MediaQuery.of(context).size.width * 0.25,
                          top: 0,
                          bottom: 40,
                          child: Center(
                            child: GestureDetector(
                              onTap: _switchToVideoMode,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: isVideoMode
                                      ? const Color.fromARGB(255, 22, 22, 22)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  "Video",
                                  style: TextStyle(
                                    color: isVideoMode
                                        ? Colors.white
                                        : Colors.white70,
                                    fontFamily: 'Arial',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          right: isVideoMode
                              ? MediaQuery.of(context).size.width * 0.25
                              : MediaQuery.of(context).size.width * 0.42,
                          top: 0,
                          bottom: 40,
                          child: Center(
                            child: GestureDetector(
                              onTap: _switchToPhotoMode,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: !isVideoMode
                                      ? const Color.fromARGB(255, 22, 22, 22)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  "Photo",
                                  style: TextStyle(
                                    color: !isVideoMode
                                        ? Colors.white
                                        : Colors.white70,
                                    fontFamily: 'Arial',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
