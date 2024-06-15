import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/pages/Home/call_homepage.dart';
import 'package:ult_whatsapp/pages/Home/chat_homepage.dart';
import 'package:ult_whatsapp/pages/Home/community_homepage.dart';
import 'package:ult_whatsapp/pages/Home/status_homepage.dart';
import 'package:ult_whatsapp/features/auth/auth_controller.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Timer timer;
  bool _isSearching = false;
  late TextEditingController _searchController;
  List<CameraDescription>? cameras;
  CameraController? cameraController;

  updateUserPresence() {
    ref.read(authControllerProvider).updateUserPresence();
  }

  @override
  void initState() {
    super.initState();
    updateUserPresence();
    timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) => setState(() {}),
    );
    _searchController = TextEditingController();
    _initializeCamera();
  }

  @override
  void dispose() {
    timer.cancel();
    _searchController.dispose();
    cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    if (cameras != null && cameras!.isNotEmpty) {
      cameraController = CameraController(cameras![0], ResolutionPreset.medium);
      await cameraController?.initialize();
    }
  }

  Future<void> _openCamera() async {
    if (await Permission.camera.request().isGranted) {
      if (cameraController != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPreview(cameraController!),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? Expanded(
                  child: Stack(
                    children: [
                      TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: TextStyle(color: Colors.white),
                        onChanged: (_) {
                          setState(() {}); // Update the state on text change
                        },
                        cursorColor: Coloors.greenDark, // Set the cursor color
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Coloors.greyDark),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Coloors.backgroundDark,
                          contentPadding: EdgeInsets.only(
                              left: 50, right: 40), // Adjusted right padding
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
              : const Text(
                  'Ult WhatsApp',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
          elevation: 0,
          actions: <Widget>[
            if (!_isSearching)
              Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: IconButton(
                  icon: Icon(
                    Icons.photo_camera_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: _openCamera,
                ),
              ),
            if (!_isSearching)
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
              ),
            if (!_isSearching)
              PopupMenuButton<int>(
                onSelected: (selected) {
                  //if someone clicks on value no. 5 which means settings
                  if (selected == 5) {
                    Navigator.pushNamed(context, "settings");
                  }
                },
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 22,
                ),
                padding: const EdgeInsets.only(right: 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                itemBuilder: (context) {
                  return <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      value: 1,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'New group',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'New broadcast',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 3,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'Linked devices',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 4,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'Starred messages',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 5,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'Settings',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    PopupMenuItem<int>(
                      value: 6,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'Switch accounts',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ];
                },
                offset: Offset(0, 45),
              ),
          ],
          bottom: _isSearching
              ? null // Hide the tabs when searching
              : const TabBar(
                  indicatorWeight: 1,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  splashFactory: NoSplash.splashFactory,
                  tabs: [
                    Tab(text: 'Community'),
                    Tab(text: 'Chats'),
                    Tab(text: 'Status'),
                    Tab(text: 'Calls'),
                  ],
                ),
        ),
        body: _isSearching
            ? null // Hide the body when searching
            : TabBarView(
                children: [
                  CommunityHomePage(),
                  ChatHomePage(),
                  StatusHomePage(),
                  CallHomePage(),
                ],
              ),
      ),
    );
  }
}
