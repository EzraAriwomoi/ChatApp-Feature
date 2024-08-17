import 'package:flutter/material.dart';
import 'dart:math';
import 'package:ult_whatsapp/common/utils/coloors.dart';

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

  Color getIconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.black // Color for light theme
        : Colors.white; // Color for dark theme
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: !_isSearching,
          iconTheme: const IconThemeData(color: Colors.white),
          title: _isSearching
              ? Expanded(
                  child: Stack(children: [
                    TextField(
                      cursorColor: Coloors.greenDark,
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      onChanged: (_) {
                        setState(() {}); // Update the state on text change
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: const TextStyle(
                            color: Coloors.greyDark, fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Coloors.backgroundDark,
                        contentPadding:
                            const EdgeInsets.only(left: 50, right: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                  });
                                },
                              )
                            : null,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchController.clear();
                        });
                      },
                    ),
                  ]),
                )
              : const Text(
                  "Settings",
                  style: TextStyle(color: Colors.white),
                ),
          actions: [
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                },
              ),
          ]),
      body: ScrollConfiguration(
        behavior: NoStretchScrollBehavior(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Row(children: [
                  Expanded(
                    child: Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.asset(
                          "assets/dp.jpg",
                          height: 65,
                          width: 65,
                        ),
                      ),
                      const SizedBox(
                          width:
                              20), // Add spacing between profile picture and details
                      const Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ezra",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "+254712345678",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Coloors.greyDark,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Hey there, I am using whatsapp.",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Coloors.greyDark,
                                ),
                              )
                            ]),
                      ),
                    ]),
                  ),
                  const SizedBox(
                      width: 20), // Add spacing between details and icons
                  const Icon(
                    Icons.qr_code_scanner_outlined,
                    color: Coloors.greenDark,
                  ),
                  const SizedBox(width: 14), // Add spacing between icons
                  const Icon(
                    Icons.arrow_drop_down_circle_outlined,
                    color: Coloors.greenDark,
                  ),
                ]),
              ),
              const Divider(
                // Add divider below the last chat item
                height: 1,
                thickness: .2,
                color: Coloors.greyLight,
                indent: 0,
                endIndent: 0,
              ),
              //account settings
              Column(children: [
                Padding(
                  padding: const EdgeInsets.only(),
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
                    title: const Text(
                      "Account",
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: const Text(
                      "Security notifications, change number",
                      style: TextStyle(
                        fontSize: 14,
                        color: Coloors.greyDark,
                      ),
                    ),
                  ),
                ),
                //privacy settings
                const Padding(
                  padding: EdgeInsets.only(),
                  child: ListTile(
                    dense: true,
                    leading: Padding(
                      padding: EdgeInsets.only(),
                      child: Icon(
                        Icons.lock,
                        color: Coloors.greyDark,
                      ),
                    ),
                    title: Text(
                      "Privacy",
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      "Block contacts, disappearing messages",
                      style: TextStyle(
                        fontSize: 14,
                        color: Coloors.greyDark,
                      ),
                    ),
                  ),
                ),
                //Avator settings
                const Padding(
                  padding: EdgeInsets.only(),
                  child: ListTile(
                    dense: true,
                    leading: Padding(
                      padding: EdgeInsets.only(),
                      child: Icon(
                        Icons.account_circle,
                        color: Coloors.greyDark,
                      ),
                    ),
                    title: Text(
                      "Avatar",
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      "Create, edit, profile photo",
                      style: TextStyle(
                        fontSize: 14,
                        color: Coloors.greyDark,
                      ),
                    ),
                  ),
                ),
                //Chat settings
                const Padding(
                  padding: EdgeInsets.only(),
                  child: ListTile(
                    dense: true,
                    leading: Padding(
                      padding: EdgeInsets.only(),
                      child: Icon(
                        Icons.message_rounded,
                        color: Coloors.greyDark,
                      ),
                    ),
                    title: Text(
                      "Chats",
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      "Theme, wallpapers, chat history",
                      style: TextStyle(
                        fontSize: 14,
                        color: Coloors.greyDark,
                      ),
                    ),
                  ),
                ),
                //Notification settings
                const Padding(
                  padding: EdgeInsets.only(),
                  child: ListTile(
                    dense: true,
                    leading: Padding(
                      padding: EdgeInsets.only(),
                      child: Icon(
                        Icons.notifications,
                        color: Coloors.greyDark,
                      ),
                    ),
                    title: Text(
                      "Notifications",
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      "Message, group & call tones",
                      style: TextStyle(
                        fontSize: 14,
                        color: Coloors.greyDark,
                      ),
                    ),
                  ),
                ),
                //Storage & data settings
                const Padding(
                  padding: EdgeInsets.only(),
                  child: ListTile(
                    dense: true,
                    leading: Padding(
                      padding: EdgeInsets.only(),
                      child: Icon(
                        Icons.data_usage_rounded,
                        color: Coloors.greyDark,
                      ),
                    ),
                    title: Text(
                      "Storage and data",
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      "Network usage, auto-download",
                      style: TextStyle(
                        fontSize: 14,
                        color: Coloors.greyDark,
                      ),
                    ),
                  ),
                ),
                //App language settings
                const Padding(
                  padding: EdgeInsets.only(),
                  child: ListTile(
                    dense: true,
                    leading: Padding(
                      padding: EdgeInsets.only(),
                      child: Icon(
                        Icons.language_rounded,
                        color: Coloors.greyDark,
                      ),
                    ),
                    title: Text(
                      "App language",
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      "English (device's language)",
                      style: TextStyle(
                        fontSize: 14,
                        color: Coloors.greyDark,
                      ),
                    ),
                  ),
                ),
                //Help settings
                const Padding(
                  padding: EdgeInsets.only(),
                  child: ListTile(
                    dense: true,
                    leading: Padding(
                      padding: EdgeInsets.only(),
                      child: Icon(
                        Icons.help_outline_rounded,
                        color: Coloors.greyDark,
                      ),
                    ),
                    title: Text(
                      "Help",
                      style: TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      "Help center, contact us, privacy policy",
                    style: TextStyle(
                      fontSize: 14,
                      color: Coloors.greyDark,
                    ),
                  ),
                ),
              ),
              //Invite a friend
              const Padding(
                padding: EdgeInsets.only(),
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(),
                    child: Icon(
                      Icons.people_alt_rounded,
                      color: Coloors.greyDark,
                    ),
                  ),
                  title: Text(
                    "Invite a friend",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              //App updates
              const Padding(
                padding: EdgeInsets.only(),
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(),
                    child: Icon(
                      Icons.security_update_good_sharp,
                      color: Coloors.greyDark,
                    ),
                  ),
                  title: Text(
                    "App updates",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              //From meta
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(children: [
                  const Text(
                    "from",
                    style: TextStyle(
                      fontSize: 14,
                      color: Coloors.greyDark,
                    ),
                  ),
                  Image.asset(
                    'assets/meta.png',
                    width: 70,
                    height: 70,
                    color: getIconColor(context),
                  ),
                ]),
              ),
            ]),
          ]),
        ),
      ),
      ),
    );
  }
}
