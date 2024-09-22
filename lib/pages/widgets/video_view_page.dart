import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewPage extends StatefulWidget {
  const VideoViewPage({Key? key, required this.path, required this.turnFlashOn}) : super(key: key);
  final String path;
  final bool turnFlashOn;

  @override
  _VideoViewPageState createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  late VideoPlayerController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        setState(() {});
        if (widget.turnFlashOn) {
          _turnFlashOn(); // Turn on flash if it was previously on
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.turnFlashOn) {
      _turnFlashOff(); // Turn off flash when leaving
    }
    super.dispose();
  }

  void _turnFlashOn() {
    // Implement the logic to turn on the flashlight
    // Assuming you have a cameraController reference, you could use something like:
    // widget.cameraController.setFlashMode(FlashMode.torch);
    print("Flashlight turned ON");
  }

  void _turnFlashOff() {
    // Implement the logic to turn off the flashlight
    // For example:
    // widget.cameraController.setFlashMode(FlashMode.off);
    print("Flashlight turned OFF");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Optionally handle any cleanup or state management before popping
        return true; // Allow the pop
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.crop_rotate, size: 27),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined, size: 27),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.title, size: 27),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 27),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              if (_controller.value.isInitialized)
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.black38,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white, fontSize: 17),
                    maxLines: 6,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Add Caption....",
                      prefixIcon: const Icon(
                        Icons.add_photo_alternate,
                        color: Colors.white,
                        size: 27,
                      ),
                      hintStyle: const TextStyle(color: Colors.white, fontSize: 17),
                      suffixIcon: CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.tealAccent[700],
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 27,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    });
                  },
                  child: CircleAvatar(
                    radius: 33,
                    backgroundColor: Colors.black38,
                    child: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
