import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/common/widgets/custom_icon_button.dart';

class PreviewPage extends StatefulWidget {
  final dynamic media;
  final bool isVideo;
  final String username;

  const PreviewPage({
    super.key,
    required this.media,
    required this.username,
    required this.isVideo,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  bool _showPlayButton = true;
  late AnimationController _buttonController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.isVideo) {
      _controller = VideoPlayerController.file(File(widget.media))
        ..initialize().then((_) {
          setState(() {
            _showPlayButton = true;
          });
          _controller!.seekTo(Duration.zero);
        });

      _controller!.addListener(() {
        if (_controller!.value.position >= _controller!.value.duration) {
          if (_isPlaying) {
            setState(() {
              _isPlaying = false;
              _showPlayButton = true;
              _buttonController.forward();
              _controller!.pause();
              _controller!.seekTo(Duration.zero);
            });
          }
        }
      });
    }

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller!.value.position >= _controller!.value.duration) {
      _controller!.seekTo(Duration.zero);
    }
    setState(() {
      if (_isPlaying) {
        _controller?.pause();
        _showPlayButton = true;
        _buttonController.forward();
      } else {
        _controller?.play();
        _showPlayButton = false;
        _buttonController.reverse();
      }
      _isPlaying = !_isPlaying;
    });
  }

  Widget _buildVideoPlayer() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
          child: CircularProgressIndicator(
        color: Coloors.greenDark,
      ));
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          if (_showPlayButton)
            Positioned(
              bottom: 320,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.black.withOpacity(0.4),
                  child: IconButton(
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      color: Color.fromARGB(202, 255, 255, 255),
                      size: 49,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
          return Stack(
            children: [
              Center(
                child: widget.isVideo
                    ? _buildVideoPlayer()
                    : Image.memory(
                        widget.media,
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
                right: widget.isVideo
                    ? 157
                    : 205, // Adjust HD position for video mode
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
                      // HD logic
                    },
                  ),
                ),
              ),
              if (!widget.isVideo)
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
                        // Rotate logic
                      },
                    ),
                  ),
                ),
              // Stickers
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
                      // Sticker logic
                    },
                  ),
                ),
              ),
              // Text
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
                      // Text logic
                    },
                  ),
                ),
              ),
              // Edit
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
                      // Editing logic
                    },
                  ),
                ),
              ),
              // Caption input field
              Positioned(
                bottom: 66 + bottomPadding,
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
              // Send button and username
              Positioned(
                bottom: bottomPadding,
                left: 0,
                right: 0,
                child: Container(
                  color: bottomPadding > 0
                      ? const Color.fromARGB(135, 24, 30, 39)
                      : const Color.fromARGB(255, 9, 15, 19),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                                widget.username,
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
                            // Send logic
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
