// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/models/message_model.dart';
import 'package:ult_whatsapp/common/models/user_model.dart';
import 'package:ult_whatsapp/common/routes/routes.dart';
import 'package:ult_whatsapp/common/widgets/custom_icon_button.dart';
import 'package:ult_whatsapp/features/chat/controller/chat_controller.dart';
import 'package:ult_whatsapp/features/chat/widgets/chat_text_field.dart';
import 'package:ult_whatsapp/features/chat/widgets/message_card.dart';
import 'package:ult_whatsapp/features/chat/widgets/show_date_card.dart';
import 'package:ult_whatsapp/features/chat/widgets/yellow_card.dart';

import '../../../common/helper/last_seen_message.dart';

final pageStorageBucket = PageStorageBucket();

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.user});

  final UserModel user;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.chatPageBgColor,
      appBar: ChatAppBar(user: widget.user),
      body: ScrollConfiguration(
        behavior: NoStretchScrollBehavior(),
        child: Stack(children: [
          // Chat background image
          Image(
            height: double.maxFinite,
            width: double.maxFinite,
            image: const AssetImage('assets/doodle_bg.png'),
            fit: BoxFit.cover,
            color: context.theme.chatPageDoodleColor,
          ),
          // Stream of Chat
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: StreamBuilder<List<MessageModel>>(
              stream: ref
                  .watch(chatControllerProvider)
                  .getAllOneToOneMessage(widget.user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.active) {
                  return ListView.builder(
                    itemCount: 15,
                    itemBuilder: (_, index) {
                      final random = Random().nextInt(14);
                      return Container(
                        alignment: random.isEven
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                          left: random.isEven ? 150 : 15,
                          right: random.isEven ? 15 : 150,
                        ),
                        child: ClipPath(
                          clipper: UpperNipMessageClipperTwo(
                            random.isEven
                                ? MessageType.send
                                : MessageType.receive,
                            nipWidth: 8,
                            nipHeight: 10,
                            bubbleRadius: 12,
                          ),
                          child: Shimmer.fromColors(
                            baseColor: random.isEven
                                ? context.theme.greyColor!.withOpacity(.3)
                                : context.theme.greyColor!.withOpacity(.2),
                            highlightColor: random.isEven
                                ? context.theme.greyColor!.withOpacity(.4)
                                : context.theme.greyColor!.withOpacity(.3),
                            child: Container(
                              height: 40,
                              width: 170 +
                                  double.parse(
                                    (random * 2).toString(),
                                  ),
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
        
                return PageStorage(
                  bucket: pageStorageBucket,
                  child: ListView.builder(
                    key: const PageStorageKey('chat_page_list'),
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (_, index) {
                      final message = snapshot.data![index];
                      final isSender = message.senderId ==
                          FirebaseAuth.instance.currentUser!.uid;
        
                      final haveNip = (index == 0) ||
                          (index == snapshot.data!.length - 1 &&
                              message.senderId !=
                                  snapshot.data![index - 1].senderId) ||
                          (message.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              message.senderId ==
                                  snapshot.data![index + 1].senderId) ||
                          (message.senderId !=
                                  snapshot.data![index - 1].senderId &&
                              message.senderId !=
                                  snapshot.data![index + 1].senderId);
                      final isShowDateCard = (index == 0) ||
                          ((index == snapshot.data!.length - 1) &&
                              (message.timeSent.day >
                                  snapshot.data![index - 1].timeSent.day)) ||
                          (message.timeSent.day >
                                  snapshot.data![index - 1].timeSent.day &&
                              message.timeSent.day <=
                                  snapshot.data![index + 1].timeSent.day);
        
                      return Column(children: [
                        if (index == 0) const YellowCard(),
                        if (isShowDateCard) ShowDateCard(date: message.timeSent),
                        MessageCard(
                          isSender: isSender,
                          haveNip: haveNip,
                          message: message,
                        ),
                      ]);
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            alignment: const Alignment(0, 1),
            child: ChatTextField(
              receiverId: widget.user.uid,
              scrollController: _scrollController, user: widget.user,
            ),
          ),
        ]),
      ),
    );
  }
}

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  final UserModel user;

  const ChatAppBar({super.key, required this.user});

  @override
  _ChatAppBarState createState() => _ChatAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChatAppBarState extends State<ChatAppBar> {
  late Timer _lastSeenTimer;
  String _lastSeen = '';

  @override
  void initState() {
    super.initState();
    _updateLastSeen();

    _lastSeenTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateLastSeen();
    });
  }

  void _updateLastSeen() async {
    final lastSeen =
        await lastSeenMessage(widget.user.uid, widget.user.lastSeen);
    if (mounted && lastSeen != _lastSeen) {
      setState(() {
        _lastSeen = lastSeen;
      });
    }
  }

  @override
  void dispose() {
    _lastSeenTimer.cancel();
    super.dispose();
  }

  void _showMoreOptions(BuildContext context, Offset position) {
    final RenderBox appBarRenderBox = context.findRenderObject() as RenderBox;
    final Offset appBarPosition = appBarRenderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;

    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(
        screenWidth - position.dx - 40,
        appBarPosition.dy + position.dy + 92,
        position.dx,
        position.dy,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: context.theme.dropdownmenu,
      items: [
        const PopupMenuItem<int>(
          value: 8,
          child: SizedBox(
            width: 140,
            child: Text(
              'Report',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ),
        const PopupMenuItem<int>(
          value: 9,
          child: SizedBox(
            width: 140,
            child: Text(
              'Block',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ),
        const PopupMenuItem<int>(
          value: 10,
          child: SizedBox(
            width: 140,
            child: Text(
              'Clear chat',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ),
        const PopupMenuItem<int>(
          value: 11,
          child: SizedBox(
            width: 140,
            child: Text(
              'Export chat',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ),
        const PopupMenuItem<int>(
          value: 12,
          child: SizedBox(
            width: 140,
            child: Text(
              'Add shortcut',
              style: TextStyle(fontSize: 12.0),
            ),
          ),
        ),
      ],
    ).then((selected) {
      if (selected == 8) {
      } else if (selected == 9) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.theme.barcolor,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(20),
        child: Row(children: [
          Icon(
            Icons.arrow_back,
            color: context.theme.baricons,
          ),
          Hero(
            tag: 'profile',
            child: Container(
              width: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image:
                      CachedNetworkImageProvider(widget.user.profileImageUrl),
                ),
              ),
            ),
          ),
        ]),
      ),
      title: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.profile,
            arguments: widget.user,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.user.username,
              style: TextStyle(
                fontSize: 18,
                color: context.theme.baricons,
              ),
            ),
            AnimatedOpacity(
              opacity: _lastSeen.isNotEmpty ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                _lastSeen,
                style: TextStyle(
                  fontSize: 12,
                  color: context.theme.baricons,
                ),
              ),
            ),
          ]),
        ),
      ),
      actions: [
        CustomIconButton(
          onPressed: () {},
          icon: Icons.videocam_outlined,
          iconColor: context.theme.baricons,
          iconSize: 28.0,
        ),
        CustomIconButton(
          onPressed: () {},
          icon: Icons.call_outlined,
          iconColor: context.theme.baricons,
        ),
        PopupMenuButton<int>(
          onSelected: (selected) {
            if (selected == 7) {
              RenderBox renderBox = context.findRenderObject() as RenderBox;
              Offset position = renderBox.localToGlobal(Offset.zero);
              _showMoreOptions(context, position);
            }
          },
          icon: Icon(
            Icons.more_vert,
            color: context.theme.baricons,
            size: 22,
          ),
          padding: const EdgeInsets.only(right: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: context.theme.dropdownmenu,
          itemBuilder: (context) {
            return <PopupMenuEntry<int>>[
              const PopupMenuItem<int>(
                value: 1,
                child: SizedBox(
                  width: 140,
                  child: Text(
                    'View contact',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: SizedBox(
                  width: 140,
                  child: Text(
                    'Media, links and docs',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
              const PopupMenuItem<int>(
                value: 3,
                child: SizedBox(
                  width: 140,
                  child: Text(
                    'Search',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
              const PopupMenuItem<int>(
                value: 4,
                child: SizedBox(
                  width: 140,
                  child: Text(
                    'Mute notifications',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
              const PopupMenuItem<int>(
                value: 5,
                child: SizedBox(
                  width: 140,
                  child: Text(
                    'Disappearing messages',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
              const PopupMenuItem<int>(
                value: 6,
                child: SizedBox(
                  width: 140,
                  child: Text(
                    'Wallpaper',
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ),
              const PopupMenuItem<int>(
                value: 7,
                child: SizedBox(
                  width: 140,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'More',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Icon(
                        Icons.arrow_right_outlined,
                        size: 20.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          offset: const Offset(0, 45),
        ),
      ],
    );
  }
}

class NoStretchScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Removes the stretching effect
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(); // Removes the iOS-style bouncing effect
  }
}
