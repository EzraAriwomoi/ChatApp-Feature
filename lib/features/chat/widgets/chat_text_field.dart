import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:ult_whatsapp/common/enum/message_type.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/common/widgets/custom_icon_button.dart';
import 'package:ult_whatsapp/features/chat/controller/chat_controller.dart';
import 'package:ult_whatsapp/pages/image_picker_page.dart';

import '../../../common/models/user_model.dart';

class ChatTextField extends ConsumerStatefulWidget {
  const ChatTextField({
    super.key,
    required this.receiverId,
    required this.scrollController,
    required this.user,
  });

  final String receiverId;
  final ScrollController scrollController;
  final UserModel user;

  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField>
    with SingleTickerProviderStateMixin {
  late TextEditingController messageController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _iconPositionAnimation;
  late Animation<double> _cameraIconAnimation;

  bool isMessageIconEnabled = false;
  double cardHeight = 0;
  bool isEmojiVisible = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController()
      ..addListener(() {
        if (messageController.text.isNotEmpty && cardHeight > 0) {
          _toggleCard();
        }
        _updateIconAnimations(messageController.text.isNotEmpty);
      });

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Icon position switch
    _iconPositionAnimation = Tween<double>(begin: 0, end: 50).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Hiding camera icon
    _cameraIconAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // switch between keyboard and emoji container
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isEmojiVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void sendImageMessageFromGallery() async {
    final image = await showModalBottomSheet<Uint8List>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ImagePickerSheet(user: widget.user),
    );

    if (image != null) {
      sendFileMessage(image, MessageType.image);
      _toggleCard();
    }
  }

  void sendFileMessage(var file, MessageType messageType) async {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverId,
          messageType,
        );
    await Future.delayed(const Duration(milliseconds: 500));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void sendTextMessage() async {
    final messageText =
        messageController.text.trimLeft();

    if (messageText.isNotEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            textMessage: messageText,
            receiverId: widget.receiverId,
          );
      messageController.clear();
    }

    await Future.delayed(const Duration(milliseconds: 100));
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _updateIconAnimations(bool isTyping) {
    if (isTyping) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  iconWithText({
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
    required Color background,
  }) {
    return Column(
      children: [
        CustomIconButton(
          onPressed: onPressed,
          icon: icon,
          background: background,
          minWidth: 50,
          iconColor: Colors.white,
          border: Border.all(
            color: context.theme.greyColor!.withOpacity(.2),
            width: 1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            color: context.theme.greyColor,
            fontFamily: 'Arial',
            fontSize: 14,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  void _toggleCard() {
    setState(() {
      if (cardHeight == 0) {
        cardHeight = 305;
        _animationController.forward();
      } else {
        cardHeight = 0;
        _animationController.reverse();
      }
    });
  }

  void _toggleEmojiPicker() {
    setState(() {
      isEmojiVisible = !isEmojiVisible;
    });
  }

  void _onEmojiSelected(Emoji emoji) {
    messageController.text += emoji.emoji;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (cardHeight > 0) {
          _toggleCard();
        }
        if (isEmojiVisible) {
          _toggleEmojiPicker();
        }
      },
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizeTransition(
            sizeFactor: _animation,
            axis: Axis.vertical,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: cardHeight,
              width: double.maxFinite,
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: context.theme.barcolor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          iconWithText(
                            onPressed: () {},
                            icon: Icons.insert_drive_file_outlined,
                            text: 'Document',
                            background: const Color(0xFF7F66FE),
                          ),
                          iconWithText(
                            onPressed: () {},
                            icon: Icons.camera_alt,
                            text: 'Camera',
                            background: const Color(0xFFFE2E74),
                          ),
                          iconWithText(
                            onPressed: sendImageMessageFromGallery,
                            icon: Icons.photo_outlined,
                            text: 'Gallery',
                            background: const Color(0xFFC861F9),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          iconWithText(
                            onPressed: () {},
                            icon: Icons.headphones,
                            text: 'Audio',
                            background: const Color(0xFFF96533),
                          ),
                          iconWithText(
                            onPressed: () {},
                            icon: Icons.location_on_rounded,
                            text: 'Location',
                            background: const Color(0xFF1FA855),
                          ),
                          iconWithText(
                            onPressed: () {},
                            icon: Icons.person_rounded,
                            text: 'Contact',
                            background: const Color(0xFF009DE1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 50),
                          iconWithText(
                            onPressed: () {},
                            icon: Icons.align_horizontal_left_rounded,
                            text: 'Poll',
                            background: const Color.fromARGB(255, 37, 158, 138),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ignore: deprecated_member_use
          WillPopScope(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: focusNode,
                      controller: messageController,
                      maxLines: 4,
                      minLines: 1,
                      onChanged: (value) {
                        setState(() {
                          isMessageIconEnabled = value.trim().isNotEmpty;
                          _updateIconAnimations(value.isNotEmpty);
                        });
                      },
                      cursorColor: Coloors.greenDark,
                      cursorHeight: 18,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Arial',
                        fontSize: 18,
                        letterSpacing: 0,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(
                          color: context.theme.greyColor,
                          fontFamily: 'Arial',
                          fontSize: 18,
                        ),
                        filled: true,
                        fillColor: context.theme.chatTextFieldBg,
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
                            onPressed: () {
                              focusNode.unfocus();
                              focusNode.canRequestFocus = false;
                              setState(() {
                                isEmojiVisible = !isEmojiVisible;
                              });
                            },
                            icon: Icons.emoji_emotions_outlined,
                            iconColor:
                                Theme.of(context).listTileTheme.iconColor,
                          ),
                        ),
                        suffixIcon:
                            Row(mainAxisSize: MainAxisSize.min, children: [
                          AnimatedBuilder(
                            animation: _iconPositionAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_iconPositionAnimation.value, 0),
                                child: CustomIconButton(
                                  onPressed: _toggleCard,
                                  icon: Icons.attach_file,
                                  iconColor:
                                      Theme.of(context).listTileTheme.iconColor,
                                ),
                              );
                            },
                          ),
                          AnimatedBuilder(
                            animation: _cameraIconAnimation,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _cameraIconAnimation.value,
                                child: Transform.translate(
                                  offset:
                                      Offset(-_iconPositionAnimation.value, 0),
                                  child: CustomIconButton(
                                    onPressed: () {},
                                    icon: Icons.camera_alt_outlined,
                                    iconColor: Theme.of(context)
                                        .listTileTheme
                                        .iconColor,
                                  ),
                                ),
                              );
                            },
                          ),
                        ]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CustomIconButton(
                    onPressed: () {
                      if (messageController.text.trim().isNotEmpty) {
                        sendTextMessage();
                      }
                    },
                    icon: isMessageIconEnabled
                        ? Icons.send_rounded
                        : Icons.mic_rounded,
                    background: Coloors.greenDark,
                    iconColor: Colors.black,
                  ),
                ],
              ),
            ),
            onWillPop: () {
              if (isEmojiVisible) {
                setState(() {
                  isEmojiVisible = false;
                });
              } else {
                Navigator.pop(context);
              }
              return Future.value(false);
            },
          ),
          if (isEmojiVisible)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  _onEmojiSelected(emoji);
                },
                config: Config(
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    columns: 9,
                    backgroundColor: context.theme.emojibackground,
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    backgroundColor: context.theme.emojibackground,
                    iconColor: context.theme.emojiiconcolor,
                    dividerColor: context.theme.emojiiconcolor,
                    iconColorSelected: context.theme.iconColorSelected,
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
