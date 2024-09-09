import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// ignore: must_be_immutable
class CameraScreen extends StatefulWidget {
  CameraController? cameraController;
  CameraScreen({super.key, this.cameraController});

  @override
  // ignore: library_private_types_in_public_api
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  FlashMode _flashMode = FlashMode.off;
  bool isRecording = false;
  bool isVideoMode = false;
  bool isFrontCamera = false;
  late AnimationController _rotationController;
  List<CameraDescription> _cameras = [];
  CameraDescription? _currentCamera;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _initializeCameras();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _initializeCameras() async {
    final cameras = await availableCameras();
    setState(() {
      _cameras = cameras;
      _currentCamera = _cameras.isNotEmpty ? _cameras.first : null;
      isFrontCamera =
          _currentCamera?.lensDirection == CameraLensDirection.front;
      if (_currentCamera != null) {
        widget.cameraController =
            CameraController(_currentCamera!, ResolutionPreset.high);
        widget.cameraController?.initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        }).catchError((error) {
          // print('Error initializing camera: $error');
        });
      }
    });
  }

  void _toggleFlash() {
    if (isFrontCamera) {
      // Toggle between 'off' and 'torch' modes only for front camera
      setState(() {
        _flashMode =
            (_flashMode == FlashMode.off) ? FlashMode.torch : FlashMode.off;
      });
    } else {
      // Cycle through 'off' -> 'torch' -> 'auto' -> 'off' for back camera
      setState(() {
        if (_flashMode == FlashMode.off) {
          _flashMode = FlashMode.torch;
        } else if (_flashMode == FlashMode.torch) {
          _flashMode = FlashMode.auto;
        } else {
          _flashMode = FlashMode.off;
        }
      });
    }

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

  void _switchToPhotoMode() {
    setState(() {
      isVideoMode = false;
    });
  }

  void _switchToVideoMode() {
    setState(() {
      isVideoMode = true;
    });
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    final newCamera = _cameras.firstWhere(
      (camera) =>
          camera.lensDirection !=
          (_currentCamera?.lensDirection ?? CameraLensDirection.back),
      orElse: () => _cameras.first,
    );

    setState(() {
      _currentCamera = newCamera;
      isFrontCamera = newCamera.lensDirection == CameraLensDirection.front;
    });

    _rotationController.forward().then((_) {
      _rotationController.reverse();
    });

    widget.cameraController =
        CameraController(_currentCamera!, ResolutionPreset.high);
    widget.cameraController?.initialize().then((_) {
      if (mounted) {
        setState(() {});
      }
    }).catchError((error) {
      // print('Error initializing camera: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.cameraController != null &&
                    widget.cameraController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: widget.cameraController!.value.aspectRatio,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..scale(isFrontCamera ? -1.0 : 1.0, 1.0, 1.0),
                      child: CameraPreview(widget.cameraController!),
                    ),
                  )
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
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
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
                          isFrontCamera
                              ? (_flashMode == FlashMode.off
                                  ? Icons.flash_off_rounded
                                  : Icons.flash_on_rounded)
                              : (_flashMode == FlashMode.off
                                  ? Icons.flash_off_rounded
                                  : _flashMode == FlashMode.torch
                                      ? Icons.flash_on_rounded
                                      : Icons.flash_auto_rounded),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),

                // Photo upload
                Positioned(
                  bottom: 134,
                  left: 12,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 13, 21, 26)
                          .withOpacity(0.4),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.photo_outlined,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        // photo upload functionality
                      },
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
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: isVideoMode ? 33 : 50,
                          height: isVideoMode ? 33 : 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Switch to selfie
                Positioned(
                  bottom: 134,
                  right: 12,
                  child: Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 13, 21, 26)
                          .withOpacity(0.4),
                    ),
                    child: AnimatedBuilder(
                      animation: _rotationController,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle:
                              _rotationController.value * 1.0 * 3.1415927, // 2π
                          child: child,
                        );
                      },
                      child: IconButton(
                        icon: const Icon(
                          Icons.loop_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: _switchCamera,
                      ),
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
