import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  List<File> _galleryImages = [];

  Timer? _timer;
  int _elapsedTime = 0;
  double _progress = 0.0;
  Color _innerCircleColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _requestPermissions().then((_) => _initializeCameras());
    _fetchGalleryImages();
  }

  Future<List<File>> _getImagesFromStorage() async {
  final directory = await getExternalStorageDirectory();
  if (directory != null) {
    final imageDirectory = Directory(directory.path);
    final List<File> imageFiles = [];
    final List<FileSystemEntity> files = imageDirectory.listSync();
    
    for (var file in files) {
      if (file is File && (file.path.endsWith('.jpg') || file.path.endsWith('.png'))) {
        imageFiles.add(file);
      }
    }
    
    return imageFiles;
  }
  return [];
}

Future<void> _fetchGalleryImages() async {
  final images = await _getImagesFromStorage();
  setState(() {
    _galleryImages = images;
  });
}

  @override
  void dispose() {
    _rotationController.dispose();
    widget.cameraController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  Future<void> _initializeCameras() async {
    final cameras = await availableCameras();
    setState(() {
      _cameras = cameras;
      _currentCamera = _cameras.isNotEmpty ? _cameras.first : null;
      isFrontCamera =
          _currentCamera?.lensDirection == CameraLensDirection.front;
      if (_currentCamera != null) {
        widget.cameraController = CameraController(
          _currentCamera!,
          ResolutionPreset.high,
          enableAudio: true,
        );
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

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedTime += 1;
        _progress = _elapsedTime % 60 / 60;
      });
    });
  }

  void _toggleFlash() {
    setState(() {
      if (isFrontCamera) {
        _flashMode =
            (_flashMode == FlashMode.off) ? FlashMode.torch : FlashMode.off;
      } else {
        _flashMode = _flashMode == FlashMode.off
            ? FlashMode.torch
            : _flashMode == FlashMode.torch
                ? FlashMode.auto
                : FlashMode.off;
      }
    });

    widget.cameraController?.setFlashMode(_flashMode);
  }

  void _captureOrRecord() async {
    if (isVideoMode) {
      if (isRecording) {
        try {
          final XFile? videoFile =
              await widget.cameraController?.stopVideoRecording();
          if (videoFile != null) {
            // print('Video recorded to: ${videoFile.path}');
          }
        } catch (e) {
          // print('Error stopping video recording: $e');
        }
        setState(() {
          isRecording = false;
          _timer?.cancel();
          _elapsedTime = 0;
          _innerCircleColor = Colors.white;
          _progress = 0.0;
        });
      } else {
        try {
          await widget.cameraController?.startVideoRecording();
          setState(() {
            isRecording = true;
            _innerCircleColor = const Color.fromARGB(255, 255, 92, 80);
            _timer?.cancel();
            _startTimer();
          });
        } catch (e) {
          // print('Error starting video recording: $e');
        }
      }
    } else {
      try {
        // print('Photo taken: ${photo?.path}');
      } catch (e) {
        // print('Error taking picture: $e');
      }
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

    _rotationController.forward().then((_) => _rotationController.reverse());

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

  void _handleHorizontalSwipe(DragEndDetails details) {
    if (details.velocity.pixelsPerSecond.dx > 0) {
      if (!isVideoMode) _switchToVideoMode();
    } else {
      if (isVideoMode) _switchToPhotoMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onHorizontalDragEnd: isRecording ? null : _handleHorizontalSwipe,
        child: Stack(
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
                  : Container(color: Colors.black),
            ),
            SafeArea(
              child: Stack(
                children: [

                  //Cancel widget
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Visibility(
                      visible: !isRecording,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 13, 21, 26)
                              .withOpacity(0.4),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.close,
                              color: Colors.white, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ),

                  //Photo upload
                  Positioned(
                    bottom: 134,
                    left: 12,
                    child: Visibility(
                      visible: !isRecording,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 13, 21, 26)
                              .withOpacity(0.4),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.photo_outlined,
                              color: Colors.white, size: 28),
                          onPressed: () {
                            // photo upload functionality
                          },
                        ),
                      ),
                    ),
                  ),

                  if (_galleryImages.isNotEmpty)
                    Positioned(
                      top: 80,
                      left: 12,
                      right: 12,
                      child: SizedBox(
                        height: 200,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Number of columns
                            crossAxisSpacing: 8.0, // Spacing between columns
                            mainAxisSpacing: 8.0, // Spacing between rows
                          ),
                          itemCount: _galleryImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Image.file(
                                _galleryImages[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                  //video and photo buttons
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black,
                      height: 110,
                      child: Stack(
                        children: [
                          Visibility(
                            visible: !isRecording,
                            child: AnimatedPositioned(
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
                                          ? const Color.fromARGB(
                                              255, 22, 22, 22)
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
                          ),
                          Visibility(
                            visible: !isRecording,
                            child: AnimatedPositioned(
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
                                          ? const Color.fromARGB(
                                              255, 22, 22, 22)
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
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Flash code
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Visibility(
                      visible: !isRecording,
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
                  ),

                  //Center capture
                  Positioned(
                    bottom: 125,
                    left: MediaQuery.of(context).size.width * 0.5 - 35,
                    child: GestureDetector(
                      onTap: isVideoMode ? _captureOrRecord : null,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(
                              value: isRecording ? _progress : 0.0,
                              strokeWidth: 5,
                              valueColor: const AlwaysStoppedAnimation(
                                Color.fromARGB(255, 255, 92, 80),
                              ),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: isVideoMode ? 33 : 50,
                            height: isVideoMode ? 33 : 50,
                            decoration: BoxDecoration(
                              color: _innerCircleColor,
                              shape: isRecording
                                  ? BoxShape.rectangle
                                  : BoxShape.circle,
                              borderRadius:
                                  isRecording ? BorderRadius.circular(8) : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //Change to selfie
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
                            angle: _rotationController.value * 2 * 3.1415927,
                            child: child,
                          );
                        },
                        child: IconButton(
                          icon: const Icon(Icons.loop_rounded,
                              color: Colors.white, size: 28),
                          onPressed: _switchCamera,
                        ),
                      ),
                    ),
                  ),


                  if (isVideoMode)
                    Positioned(
                      top: 12,
                      left: MediaQuery.of(context).size.width * 0.5 - 30,
                      child: Container(
                        width: 60,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isRecording
                              ? const Color.fromARGB(255, 255, 92, 80)
                              : const Color.fromARGB(255, 13, 21, 26)
                                  .withOpacity(0.4),
                        ),
                        child: Center(
                          child: Text(
                            '${(_elapsedTime ~/ 60).toString().padLeft(2, '0')}:${(_elapsedTime % 60).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Arial'),
                          ),
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
  }
}
