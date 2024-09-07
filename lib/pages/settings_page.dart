import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_isSearching) {
          setState(() {
            _isSearching = false;
            _searchController.clear();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: context.theme.barcolor,
          iconTheme: IconThemeData(color: context.theme.baricons),
          title: _isSearching
              ? Stack(
                  children: [
                    TextField(
                      cursorColor: Coloors.greenDark,
                      cursorHeight: 15,
                      controller: _searchController,
                      autofocus: true,
                      style: TextStyle(
                        color: context.theme.baricons,
                        fontFamily: 'Arial',
                        fontSize: 16,
                        letterSpacing: 0,
                      ),
                      onChanged: (_) {
                        setState(() {}); // Update the state on text change
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 87, 96, 104),
                          fontSize: 16,
                          fontFamily: 'Arial',
                          letterSpacing: 0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: context.theme.seachbarColor,
                        contentPadding:
                            const EdgeInsets.only(left: 50, right: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                color: context.theme.baricons,
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: context.theme.baricons,
                        onPressed: () {
                          setState(() {
                            _isSearching = false;
                            _searchController.clear();
                          });
                        },
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: context.theme.baricons,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          color: context.theme.baricons,
                          fontFamily: 'Arial',
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
          actions: [
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.search),
                color: context.theme.baricons,
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
              ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: context.theme.line,
              height: 0.5,
            ),
          ),
        ),
        body: ScrollConfiguration(
          behavior: NoStretchScrollBehavior(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              child: Column(children: [
                InkWell(
                  onTap: () {
                    // Add tap action
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 15),
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          "assets/dp.jpg",
                          height: 65,
                          width: 65,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ezra",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Arial',
                              ),
                            ),
                            Text(
                              "+254 712 345678",
                              style: TextStyle(
                                color: context.theme.greyColor,
                                fontFamily: 'Arial',
                                fontSize: 14,
                                letterSpacing: 0,
                              ),
                            ),
                            Text(
                              "Available",
                              style: TextStyle(
                                color: context.theme.greyColor,
                                fontFamily: 'Arial',
                                fontSize: 14,
                                letterSpacing: 0,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.qr_code_rounded,
                        color: Coloors.greenDark,
                      ),
                      const SizedBox(width: 14),
                      const Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        color: Coloors.greenDark,
                      ),
                    ]),
                  ),
                ),
                Divider(
                  height: 0.2,
                  thickness: 0.5,
                  color: context.theme.line,
                ),
                const SizedBox(height: 3),
                // Account settings
                InkWell(
                  onTap: () {
                    // Add tap action for Account
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: ListTile(
                      dense: true,
                      leading: Padding(
                        padding: const EdgeInsets.only(),
                        child: Transform.rotate(
                          angle: pi / 2,
                          child: const Icon(
                            Icons.key,
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                      title: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Account",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      subtitle: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Security notifications, change number",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Arial',
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Privacy settings
                InkWell(
                  onTap: () {
                    // Add tap action for Privacy
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.lock,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Privacy",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Block contacts, disappearing messages",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Arial',
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Avatar settings
                InkWell(
                  onTap: () {
                    // Add tap action for Avatar
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.account_circle,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Avatar",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Create, edit, profile photo",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Arial',
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Favorites settings
                InkWell(
                  onTap: () {
                    // Add tap action for Favorites
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.favorite_outline_outlined,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Favorites",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Add, reorder, remove",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Arial',
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Chat settings
                InkWell(
                  onTap: () {
                    // Add tap action for Chats
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.message_rounded,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Chats",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Theme, wallpapers, chat history",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Arial',
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Notification settings
                InkWell(
                  onTap: () {
                    // Add tap action for Notifications
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.notifications,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Notifications",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Message, group & call tones",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Arial',
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Storage and data settings
                InkWell(
                  onTap: () {
                    // Add tap action for Storage and Data
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.data_usage_rounded,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Storage and data",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Network usage, auto-download",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Arial',
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //App language settings
                InkWell(
                  onTap: () {
                    // Add tap action for language settings
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.language_rounded,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "App language",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "English (device's language)",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Arial',
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Help settings
                InkWell(
                  onTap: () {
                    // Add tap action for Help settings
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.help_outline_rounded,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Help",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Help center, contact us, privacy policy",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Arial',
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Invite a friend
                InkWell(
                  onTap: () {
                    // Add tap action for Invite a friend
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.people_alt_rounded,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Invite a friend",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //App updates
                InkWell(
                  onTap: () {
                    // Add tap action for App updates
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                    child: ListTile(
                      dense: true,
                      leading: Icon(
                        Icons.system_security_update_good_outlined,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "App updates",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Also from Meta',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 14,
                          color: context.theme.greyColor,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                ),

                //Instagram
                InkWell(
                  onTap: () {
                    // Add tap action for instagram
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: ListTile(
                      dense: true,
                      leading: FaIcon(
                        FontAwesomeIcons.instagram,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Open Instagram",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //Facebook
                InkWell(
                  onTap: () {
                    // Add tap action for facebook
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: ListTile(
                      dense: true,
                      leading: FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Coloors.greyDark,
                      ),
                      title: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Open Facebook",
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
