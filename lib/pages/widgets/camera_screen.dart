import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  final CameraController? cameraController;
  const CameraScreen({Key? key, this.cameraController}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isFlashOn = false; // Flashlight state
  bool isRecording = false; // Video recording state
  bool isVideoMode = false; // Default mode is Photo mode

  // Toggle flash state
  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });

    widget.cameraController?.setFlashMode(
      isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  // Capture photo or start/stop recording video
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
      body: Stack(
        children: [
          // Camera Preview (Reduced height)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75, // Reduced height
              child: CameraPreview(widget.cameraController!),
            ),
          ),

          // Close button (top left)
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context); // Close camera and return to home
              },
            ),
          ),

          // Flashlight toggle (top right)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _toggleFlash,
            ),
          ),

          // Primary Photo Button (center bottom)
          Positioned(
            bottom: 130,
            left: MediaQuery.of(context).size.width * 0.5 - 35, // Center
            child: GestureDetector(
              onTap: isVideoMode
                  ? null
                  : _captureOrRecord, // Only work in Photo mode
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 35,
                ),
              ),
            ),
          ),

          // Animated text for Photo and Video mode selection
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black,
              height: 110, // Set a defined height
              child: Stack(
                children: [
                  // Animated "Video" button (left or center)
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
                              color: isVideoMode ? Colors.white : Colors.white70,
                              fontFamily: 'Arial',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Animated "Photo" button (center or right)
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
                              color: !isVideoMode ? Colors.white : Colors.white70,
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
    );
  }
}
