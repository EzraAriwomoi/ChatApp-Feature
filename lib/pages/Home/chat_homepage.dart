// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/models/last_message_model.dart';
import 'package:ult_whatsapp/common/routes/routes.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/features/chat/repository/chat_repository.dart';

import '../../features/popups/end_to_end_encrypted.dart';

final newContactsLoadingProvider = StateProvider<bool>((ref) => false);

navigateToContactPage(context) {
  Navigator.pushNamed(context, Routes.contact);
}

class NoStretchScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

String _formatTime(DateTime timeSent) {
  final now = DateTime.now();
  final todayMidnight = DateTime(now.year, now.month, now.day);
  final yesterdayMidnight = todayMidnight.subtract(const Duration(days: 1));

  if (timeSent.isAfter(todayMidnight)) {
    // If the message was sent today, show the time in AM/PM format
    return DateFormat.jm().format(timeSent);
  } else if (timeSent.isAfter(yesterdayMidnight)) {
    // If the message was sent yesterday, display 'yesterday'
    return 'Yesterday';
  } else {
    // If the message is older than yesterday, show the date in DD/MM/YY format
    return DateFormat('d/M/yy').format(timeSent);
  }
}

class ChatHomePage extends ConsumerStatefulWidget {
  const ChatHomePage({super.key});

  @override
  _ChatHomePageState createState() => _ChatHomePageState();
}

class _ChatHomePageState extends ConsumerState<ChatHomePage> {
  Timer? _timer;
  List<LastMessageModel> _previousChats = [];

  @override
  void initState() {
    super.initState();
    _startChatCheck();
  }

  void _startChatCheck() {
    _timer = Timer.periodic(const Duration(seconds: 20), (timer) async {
      final chatsStream =
          ref.read(chatRepositoryProvider).getAllLastMessageList();
      chatsStream.listen((currentChats) {
        bool newChats = !_areChatsEqual(currentChats, _previousChats);

        if (newChats) {
          ref.read(newContactsLoadingProvider.notifier).state = true;
          Future.delayed(const Duration(seconds: 1), () {
            ref.read(newContactsLoadingProvider.notifier).state = false;
          });

          // Update previous chats
          _previousChats = currentChats;
        }
      });
    });
  }

  bool _areChatsEqual(
      List<LastMessageModel> list1, List<LastMessageModel> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].contactId != list2[i].contactId) return false;
    }
    return true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<LastMessageModel>>(
        stream: ref.read(chatRepositoryProvider).getAllLastMessageList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Coloors.greenDark,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading chats'),
            );
          } else if (snapshot.hasData) {
            final chats = snapshot.data!;
            return ScrollConfiguration(
              behavior: NoStretchScrollBehavior(),
              child: ListView(
                children: [
                  ...chats.map((chat) => ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(chat.profileImageUrl),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              chat.username,
                              style: const TextStyle(fontSize: 17,fontFamily: 'Arial'),
                            ),
                            Text(
                              _formatTime(chat.timeSent),
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Arial',
                                letterSpacing: 0,
                                color: context.theme.greyColor,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          chat.lastMessage,
                          style: TextStyle(
                            fontSize: 16,
                            color: context.theme.greyColor,
                            fontFamily: 'Arial',
                            letterSpacing: 0,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 2.0, horizontal: 10.0),
                        onTap: () async {
                          final userModel = await ref
                              .read(chatRepositoryProvider)
                              .getUserModelById(chat.contactId);
                          if (userModel != null) {
                            Navigator.pushNamed(
                              context,
                              Routes.chat,
                              arguments: userModel,
                            );
                          }
                        },
                      )),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      "Tap and hold on a chat for more options",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial',
                        color: context.theme.greyColor,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 0.2,
                    color: context.theme.line,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: context.theme.greyColor,
                          size: 10,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Your personal messages are",
                          style: TextStyle(
                            color: context.theme.greyColor,
                            fontSize: 12,
                            fontFamily: 'Arial',
                            letterSpacing: 0,
                          ),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            showEndToEndBottomSheet(context);
                          },
                          child: const Text(
                            "end-to-end encrypted",
                            style: TextStyle(
                              color: Coloors.greenDark,
                              fontSize: 12,
                              fontFamily: 'Arial',
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('No chats available'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToContactPage(context),
        child: const Icon(Icons.message_rounded),
      ),
    );
  }
}
