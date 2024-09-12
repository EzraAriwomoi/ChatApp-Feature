// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';
import 'package:ult_whatsapp/features/popups/popup_verification.dart';
import 'package:ult_whatsapp/pages/Home/call_homepage.dart';
import 'package:ult_whatsapp/pages/Home/chat_homepage.dart';
import 'package:ult_whatsapp/pages/Home/community_homepage.dart';
import 'package:ult_whatsapp/pages/Home/status_homepage.dart';
import 'package:ult_whatsapp/features/auth/auth_controller.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ult_whatsapp/pages/widgets/camera_screen.dart';

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
      cameraController = CameraController(cameras![0], ResolutionPreset.high);
      await cameraController?.initialize();
    }
  }

  Future<void> _openCamera() async {
  // Request camera permission
  if (await Permission.camera.request().isGranted) {
    if (cameraController != null && cameraController!.value.isInitialized) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(cameraController: cameraController),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera is not initialized')),
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_isSearching) {
          setState(() {
            _isSearching = false;
            _searchController.clear();
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: context.theme.barcolor,
          title: _isSearching
              ? Expanded(
                  child: Stack(
                    children: [
                      TextField(
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
                        cursorColor: Coloors.greenDark,
                        cursorHeight: 15,
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: context.theme.greyColor,
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
                              const EdgeInsets.only(left: 50, right: 40),
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
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: context.theme.baricons,
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
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: _getAppBarTitle() == 'Ult WhatsApp'
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: _getAppBarTitle() == 'Ult WhatsApp' ? 25 : 20,
                      color: _getAppBarTitle() == 'Ult WhatsApp'
                          ? context.theme.barheadcolor
                          : context.theme.baricons),
                ),
          elevation: 0,
          //line below the appbar
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              height: 0.2,
              color: context.theme.line,
            ),
          ),
          actions: <Widget>[
            if (!_isSearching)
              Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: IconButton(
                  icon: Icon(
                    Icons.photo_camera_rounded,
                    color: context.theme.baricons,
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
                    color: context.theme.baricons,
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
                  } else if (selected == 6) {
                    PopupVerification.showVerificationPopup(context);
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
                          'New group',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'New broadcast',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 3,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'Linked devices',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 4,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'Starred messages',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 5,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'Settings',
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 6,
                      child: SizedBox(
                        width: 140,
                        child: Text(
                          'Switch accounts',
                          style: TextStyle(fontSize: 12.0),
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
          color: context.theme.barcolor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            //line above the bottombar context.theme.baricons,
            children: [
              Container(
                height: 0.2,
                color: context.theme.line,
              ),
              SizedBox(
                height: 80,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: context.theme.barcolor,
                  selectedItemColor: context.theme.baricons,
                  unselectedItemColor: context.theme.baricons,
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  items: [
                    _buildBottomNavigationBarItem(
                      icon: Icons.chat,
                      label: 'Chats',
                      isSelected: _selectedIndex == 0,
                    ),
                    _buildBottomNavigationBarItem(
                      icon: Icons.motion_photos_on_rounded,
                      label: 'Status',
                      isSelected: _selectedIndex == 1,
                    ),
                    _buildBottomNavigationBarItem(
                      icon: Icons.groups_outlined,
                      label: 'Community',
                      isSelected: _selectedIndex == 2,
                    ),
                    _buildBottomNavigationBarItem(
                      icon: Icons.call_outlined,
                      label: 'Calls',
                      isSelected: _selectedIndex == 3,
                    ),
                  ],
                  selectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                  ),
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isSelected ? 60 : 30,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color.fromARGB(255, 180, 240, 229)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(isSelected ? 18 : 0),
        ),
        child: Center(
          child: Icon(
            icon,
            color: isSelected
                ? const Color.fromARGB(255, 0, 88, 72)
                : context.theme.baricons,
          ),
        ),
      ),
      label: label,
    );
  }
}
