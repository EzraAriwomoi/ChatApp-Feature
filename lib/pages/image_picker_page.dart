import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import '../common/models/user_model.dart';
import '../common/widgets/custom_icon_button.dart';
import 'widgets/preview.dart';

class ImagePickerSheet extends StatefulWidget {
  const ImagePickerSheet({super.key, required this.user});

  final UserModel user;

  @override
  State<ImagePickerSheet> createState() => _ImagePickerSheetState();
}

class _ImagePickerSheetState extends State<ImagePickerSheet>
    with SingleTickerProviderStateMixin {
  List<Widget> mediaList = [];
  int currentPage = 0;
  int? lastPage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchAllMedia();
  }

  Future<void> fetchAllMedia() async {
    lastPage = currentPage;
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) return PhotoManager.openSetting();

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.all,
      onlyAll: true,
    );

    List<AssetEntity> media = await albums[0].getAssetListPaged(
      page: currentPage,
      size: 24,
    );

    List<Widget> temp = [];

    for (var asset in media) {
      if (asset.type == AssetType.image || asset.type == AssetType.video) {
        temp.add(
          FutureBuilder(
            future: asset.thumbnailDataWithSize(
              const ThumbnailSize(200, 200),
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () async {
                      if (asset.type == AssetType.video) {
                        final File? file = await asset.file;
                        if (file != null) {
                          Navigator.push(
                            // ignore: use_build_context_synchronously
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder: (_, __, ___) => PreviewPage(
                                media: file.path,
                                username: widget.user.username,
                                isVideo: true,
                              ),
                              transitionsBuilder: (_, animation, __, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOut;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        }
                      } else {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 500),
                            pageBuilder: (_, __, ___) => PreviewPage(
                              media: snapshot.data as Uint8List,
                              username: widget.user.username,
                              isVideo: false,
                            ),
                            transitionsBuilder: (_, animation, __, child) {
                              const begin =
                                  Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(5),
                    splashFactory: NoSplash.splashFactory,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: context.theme.barcolor!.withOpacity(0.0),
                            ),
                            image: DecorationImage(
                              image: MemoryImage(snapshot.data as Uint8List),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (asset.type == AssetType.video)
                          const Positioned(
                              bottom: 4,
                              left: 4,
                              child: Icon(
                                Icons.videocam_outlined,
                                color: Colors.white,
                              )),
                        if (asset.type == AssetType.video)
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                _formatDuration(asset.videoDuration),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Arial'),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        );
      }
    }

    setState(() {
      mediaList.addAll(temp);
      currentPage++;
    });
  }

  // Function to format the video duration as mm:ss
  String _formatDuration(Duration duration) {
    final int seconds = duration.inSeconds;
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent <= .33) return;
    if (currentPage == lastPage) return;
    fetchAllMedia();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.952,
      minChildSize: 0.5,
      maxChildSize: 0.952,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(34)),
          child: Scaffold(
            backgroundColor: context.theme.barcolor,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(136.0),
              child: AppBar(
                backgroundColor: context.theme.barcolor,
                leading: Padding(
                  padding: const EdgeInsets.only(top: 36.0),
                  child: CustomIconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.close,
                    iconSize: 24,
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 35.0),
                  child: Text(
                    'Send to ${widget.user.username}',
                    style: TextStyle(
                      color: context.theme.authAppbarTextColor,
                      fontFamily: 'Arial',
                      fontSize: 23,
                      letterSpacing: 0,
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 34.0),
                    child: CustomIconButton(
                      onPressed: () {},
                      icon: Icons.check_box_outlined,
                      iconSize: 24,
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(30.0),
                  child: TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Recents'),
                      Tab(text: 'Gallery'),
                    ],
                    labelStyle: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 16,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
            body: ScrollConfiguration(
              behavior: NoStretchScrollBehavior(),
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Recents
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scroll) {
                        handleScrollEvent(scroll);
                        return true;
                      },
                      child: GridView.builder(
                        controller: scrollController,
                        itemCount: mediaList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (_, index) {
                          return mediaList[index];
                        },
                      ),
                    ),
                  ),
                  // Gallery View
                  const Center(child: Text('Gallery View Content')),
                ],
              ),
            ),
          ),
        );
      },
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
