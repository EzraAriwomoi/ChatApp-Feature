// ignore_for_file: use_build_context_synchronously

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
  int _selectedIndex = 0; // Default to the 'Chats' tab

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
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 1:
        return 'Statuses';
      case 2:
        return 'Communities';
      case 3:
        return 'Calls';
      default:
        return 'Ult WhatsApp';
    }
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const ChatHomePage();
      case 1:
        return const StatusHomePage();
      case 2:
        return const CommunityHomePage();
      case 3:
        return const CallHomePage();
      default:
        return const ChatHomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Coloors.backgroundDark,
        title: _isSearching
            ? Expanded(
                child: Stack(
                  children: [
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (_) {
                        setState(() {}); // Update the state on text change
                      },
                      cursorColor: Coloors.greenDark,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle: const TextStyle(color: Coloors.greyDark),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Coloors.backgroundDark,
                        contentPadding:
                            const EdgeInsets.only(left: 50, right: 40),
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
                  ],
                ),
              )
            : Text(
                _getAppBarTitle(),
                style: const TextStyle(
                  letterSpacing: 1,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
        elevation: 0,
        //line below the appbar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            color: Coloors.greyBackground,
          ),
        ),
        actions: <Widget>[
          if (!_isSearching)
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: IconButton(
                icon: const Icon(
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
                icon: const Icon(
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
                if (selected == 5) {
                  Navigator.pushNamed(context, "settings");
                }
              },
              icon: const Icon(
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
                  const PopupMenuItem<int>(
                    value: 1,
                    child: SizedBox(
                      width: 140,
                      child: Text(
                        'New group',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: SizedBox(
                      width: 140,
                      child: Text(
                        'New broadcast',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: SizedBox(
                      width: 140,
                      child: Text(
                        'Linked devices',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 4,
                    child: SizedBox(
                      width: 140,
                      child: Text(
                        'Starred messages',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 5,
                    child: SizedBox(
                      width: 140,
                      child: Text(
                        'Settings',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
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
              offset: const Offset(0, 45),
            ),
        ],
      ),
      body: _isSearching ? null : _buildBody(),
      bottomNavigationBar: Container(
        color: Coloors.backgroundDark,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //line above the bottombar
          children: [
            Container(
              height: 1,
              color: Coloors.greyBackground,
            ),
            SizedBox(
              height: 80,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Coloors.backgroundDark,
                selectedItemColor: Coloors.greenDark,
                unselectedItemColor: Colors.white,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.blur_circular_outlined),
                    label: 'Status',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.groups_outlined),
                    label: 'Community',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.call_outlined),
                    label: 'Calls',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
