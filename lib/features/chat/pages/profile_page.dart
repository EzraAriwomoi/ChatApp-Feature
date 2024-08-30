// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/helper/last_seen_message.dart';
import 'package:ult_whatsapp/common/models/user_model.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/common/widgets/custom_icon_button.dart';
import 'package:ult_whatsapp/features/chat/widgets/custom_list_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: NoStretchScrollBehavior(),
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: SliverPersistentDelegate(user),
              pinned: true,
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    color: Coloors.backgroundDark,
                    child: Column(
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.phoneNumber,
                          style: TextStyle(
                            fontSize: 20,
                            color: context.theme.greyColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LastSeenSection(user: user),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            iconWithText(
                                icon: Icons.call_outlined, text: 'Audio'),
                            iconWithText(
                                icon: Icons.video_call_rounded, text: 'Video'),
                            iconWithText(icon: Icons.search, text: 'Search'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 30),
                    title: const Text('Hey there! I am using WhatsApp'),
                    subtitle: Text(
                      'August 9, 2023',
                      style: TextStyle(
                        color: context.theme.greyColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomListTile(
                    title: 'Mute notification',
                    leading: Icons.notifications,
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                  const CustomListTile(
                    title: 'Custom notification',
                    leading: Icons.music_note,
                  ),
                  CustomListTile(
                    title: 'Media visibility',
                    leading: Icons.photo,
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                    ),
                  ),
                  const SizedBox(height: 20),
                  const CustomListTile(
                    title: 'Encryption',
                    subTitle:
                        'Messages and calls are end-to-end encrypted, Tap to verify.',
                    leading: Icons.lock,
                  ),
                  const CustomListTile(
                    title: 'Disappearing messages',
                    subTitle: 'Off',
                    leading: Icons.timer,
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: CustomIconButton(
                      onPressed: () {},
                      icon: Icons.group,
                      background: Coloors.greenDark,
                      iconColor: Colors.white,
                    ),
                    title: Text('Create group with ${user.username}'),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 25, right: 10),
                    leading: const Icon(
                      Icons.block,
                      color: Color(0xFFF15C6D),
                    ),
                    title: Text(
                      'Block ${user.username}',
                      style: const TextStyle(
                        color: Color(0xFFF15C6D),
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(left: 25, right: 10),
                    leading: const Icon(
                      Icons.thumb_down,
                      color: Color(0xFFF15C6D),
                    ),
                    title: Text(
                      'Report ${user.username}',
                      style: const TextStyle(
                        color: Color(0xFFF15C6D),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  iconWithText({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(
          icon,
          size: 30,
          color: Coloors.greenDark,
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: const TextStyle(color: Coloors.greenDark),
        ),
      ]),
    );
  }
}

class SliverPersistentDelegate extends SliverPersistentHeaderDelegate {
  final UserModel user;

  final double maxHeaderHeight = 180;
  final double minHeaderHeight = kToolbarHeight + 45;
  final double maxImageSize = 130;
  final double minImageSize = 40;

  SliverPersistentDelegate(this.user);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final size = MediaQuery.of(context).size;
    final percent = shrinkOffset / (maxHeaderHeight - 35);
    final percent2 = shrinkOffset / (maxHeaderHeight);
    final currentImageSize = (maxImageSize * (1 - percent)).clamp(
      minImageSize,
      maxImageSize,
    );
    final currentImagePosition = ((size.width / 2 - currentImageSize / 2) * (1 - percent)).clamp(
      minImageSize,
      size.width - currentImageSize,
    );

    return Container(
      color: Coloors.backgroundDark,
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).viewPadding.top + 20,
            left: currentImagePosition + 50,
            child: Text(
              user.username,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white.withOpacity(percent2),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: MediaQuery.of(context).viewPadding.top + 5,
            child: BackButton(
              color: percent2 > .3 ? Colors.white.withOpacity(percent2) : null,
            ),
          ),
          Positioned(
            right: 0,
            top: MediaQuery.of(context).viewPadding.top + 5,
            child: CustomIconButton(
              onPressed: () {},
              icon: Icons.more_vert,
              iconColor: percent2 > .3
                  ? Colors.white.withOpacity(percent2)
                  : Theme.of(context).textTheme.bodyMedium!.color,
            ),
          ),
          Positioned(
            left: currentImagePosition,
            top: MediaQuery.of(context).viewPadding.top + 5,
            bottom: 0,
            child: Hero(
              tag: 'profile',
              child: Container(
                width: currentImageSize,
                height: currentImageSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(user.profileImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, // Positioning at the bottom of the header
            left: 0,
            right: 0,
            child: Visibility(
              visible: currentImageSize <= minImageSize, // Only show the divider when the image is at its minimum size
              child: Divider(
                height: 1,
                color: context.theme.greyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
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

class LastSeenSection extends StatefulWidget {
  const LastSeenSection({super.key, required this.user});

  final UserModel user;

  @override
  _LastSeenSectionState createState() => _LastSeenSectionState();
}

class _LastSeenSectionState extends State<LastSeenSection> {
  Timer? _statusTimer;
  String _lastSeen = '';

  @override
  void initState() {
    super.initState();
    _startStatusTimer();
    _updateLastSeen();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  void _startStatusTimer() {
    _statusTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateLastSeen();
    });
  }

  void _updateLastSeen() async {
    final lastSeen =
        await lastSeenMessage(widget.user.uid, widget.user.lastSeen);
    if (mounted) {
      setState(() {
        _lastSeen = lastSeen;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _lastSeen,
      style: TextStyle(
        fontSize: 16,
        color: context.theme.greyColor,
      ),
    );
  }
}
