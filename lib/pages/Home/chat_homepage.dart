// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/models/last_message_model.dart';
import 'package:ult_whatsapp/common/routes/routes.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/features/chat/repository/chat_repository.dart';

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
              child: ListView.builder(
                itemCount:
                    chats.length + 1, // +1 for the "Start a new chat" header
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Display the "Start a new chat" header
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 0,
                      ),
                    );
                  } else {
                    final LastMessageModel chat = chats[index - 1];
                    return ListTile(
                      leading: CircleAvatar(
                        radius:
                            25, // Adjust the radius to resize the profile photo
                        backgroundImage: NetworkImage(chat.profileImageUrl),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            chat.username,
                            style: const TextStyle(
                                fontSize: 17), // Adjust font size for username
                          ),
                          Text(
                            _formatTime(chat.timeSent),
                            style: TextStyle(
                              fontSize: 12, // Adjust font size for time
                              color: context.theme.greyColor,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        chat.lastMessage,
                        style: const TextStyle(
                          fontSize: 15, // Adjust font size for last message
                          color: Color(0xFF667781),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 10.0),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.chat,
                          arguments: chat.contactId,
                        );
                      },
                    );
                  }
                },
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
