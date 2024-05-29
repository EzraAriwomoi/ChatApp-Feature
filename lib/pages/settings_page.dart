import 'package:flutter/material.dart';
import 'dart:math';
import 'package:ult_whatsapp/common/utils/coloors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();

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
        iconTheme: IconThemeData(color: Colors.white),
        title: _isSearching
            ? Expanded(
                child: Stack(
                  children: [
                    TextField(
                      cursorColor: Coloors.greenDark,
                      controller: _searchController,
                      autofocus: true,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      onChanged: (_) {
                        setState(() {}); // Update the state on text change
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Coloors.greyDark, fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Coloors.backgroundDark,
                        contentPadding: EdgeInsets.only(left: 50, right: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear),
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
                      icon: Icon(Icons.arrow_back),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          _isSearching = false;
                          _searchController.clear();
                        });
                      },
                    ),
                  ],
                ),
              )
            : Text(
                "Settings",
                style: TextStyle(color: Colors.white),
              ),
        actions: [
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = true;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              "assets/dp.jpg",
                              height: 65,
                              width: 65,
                            ),
                          ),
                          SizedBox(
                              width:
                                  20), // Add spacing between profile picture and details
                          Expanded(
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: 20), // Add spacing between details and icons
                    Icon(
                      Icons.qr_code_scanner_outlined,
                      color: Coloors.greenDark,
                    ),
                    SizedBox(width: 14), // Add spacing between icons
                    Icon(
                      Icons.arrow_drop_down_circle_outlined,
                      color: Coloors.greenDark,
                    ),
                  ],
                ),
              ),
              Divider(
                // Add divider below the last chat item
                height: 1,
                thickness: .2,
                color: Coloors.greyLight,
                indent: 0, // Set indent to 0 to start from the far left
                endIndent: 0, // Set endIndent to 0 to end at the far right
              ),
              //account settings
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(),
                    child: ListTile(
                      dense: true,
                      leading: Padding(
                        padding: EdgeInsets.only(),
                        child: Transform.rotate(
                          angle: pi / 2,
                          child: Icon(
                            Icons.key,
                            color: Coloors.greyDark,
                          ),
                        ),
                      ),
                      title: Text(
                        "Account",
                        style: TextStyle(fontSize: 15),
                      ),
                      subtitle: Text(
                        "Security notifications, change number",
                        style: TextStyle(
                          fontSize: 14,
                          color: Coloors.greyDark,
                        ),
                      ),
                    ),
                  ),
                  //privacy settings
                  Padding(
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
                  Padding(
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
                  Padding(
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
                  Padding(
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
                  Padding(
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
                  Padding(
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
                  Padding(
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
                  Padding(
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
                  Padding(
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
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        Text(
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
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
