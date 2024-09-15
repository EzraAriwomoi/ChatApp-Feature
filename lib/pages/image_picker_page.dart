import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import '../common/widgets/custom_icon_button.dart';

class ImagePickerSheet extends StatefulWidget {
  const ImagePickerSheet({super.key});

  @override
  State<ImagePickerSheet> createState() => _ImagePickerSheetState();
}

class _ImagePickerSheetState extends State<ImagePickerSheet>
    with SingleTickerProviderStateMixin {
  List<Widget> mediaList = [];
  List<AssetPathEntity> albumList = [];
  int currentPage = 0;
  int? lastPage;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchAllMedia();
    fetchAlbums();
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
                    onTap: () => Navigator.pop(context, snapshot.data),
                    borderRadius: BorderRadius.circular(5),
                    splashFactory: NoSplash.splashFactory,
                    child: Container(
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

  Future<void> fetchAlbums() async {
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) return PhotoManager.openSetting();

    // Fetch albums grouped by folder names
    albumList = await PhotoManager.getAssetPathList(
      type: RequestType.all, // Both photos and videos
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(minHeight: 1, minWidth: 1),
        ),
        videoOption: const FilterOption(
          sizeConstraint: SizeConstraint(minHeight: 1, minWidth: 1),
        ),
        orders: [
          const OrderOption(
            type: OrderOptionType.createDate,
            asc: false,
          ),
        ],
      ),
    );

    setState(() {});
  }

  Widget buildAlbumItem(AssetPathEntity album) {
  return FutureBuilder(
    future: album.getAssetListRange(start: 0, end: 1), // Get the first asset for thumbnail
    builder: (context, AsyncSnapshot<List<AssetEntity>> snapshot) {
      if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.isNotEmpty) {
        AssetEntity asset = snapshot.data!.first;
        return FutureBuilder(
          future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
          builder: (context, thumbnailSnapshot) {
            if (thumbnailSnapshot.connectionState == ConnectionState.done && thumbnailSnapshot.hasData) {
              return ListTile(
                leading: Image.memory(
                  thumbnailSnapshot.data as Uint8List,
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
                title: Text(
                  album.name,
                  style: const TextStyle(fontSize: 16),
                ),
                subtitle: FutureBuilder(
                  future: album.assetCountAsync,
                  builder: (context, countSnapshot) {
                    if (countSnapshot.connectionState == ConnectionState.done && countSnapshot.hasData) {
                      return Text('${countSnapshot.data} items');
                    }
                    return const Text('Loading...');
                  },
                ),
                onTap: () {
                  // Handle album click (e.g., navigate to another screen to show album contents)
                },
              );
            }
            return const SizedBox();
          },
        );
      }
      return const SizedBox();
    },
  );
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
                  padding: const EdgeInsets.only(top: 45.0),
                  child: Text(
                    'Send to',
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
                  // Gallery View (Albums grouped by name)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: albumList.length,
                      itemBuilder: (_, index) {
                        return buildAlbumItem(albumList[index]);
                      },
                    ),
                  ),
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
