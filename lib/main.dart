import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:statusviewer/src/app.dart';
import 'package:statusviewer/src/components/ad_state.dart';
import 'package:statusviewer/src/data/repository/photo_repo.dart';
import 'package:statusviewer/src/data/repository/video_repo.dart';
import 'package:statusviewer/src/screens/photo_screen.dart';
import 'package:statusviewer/src/screens/video_screen.dart';
import 'package:statusviewer/src/utils/cache_svg_images.dart';
import 'package:statusviewer/src/utils/theme.dart';
import 'package:super_easy_permissions/super_easy_permissions.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //##################### uncomment for Admob ########################
  // final initFuture = MobileAds.instance.initialize();
  // final adState = AdState(initFuture);

  final PhotoRepository photoRepository = PhotoRepository();
  final VideoRepository videoRepository = VideoRepository();
  // await preCacheSvgs();
  runApp(MyApp(
      photoRepository: photoRepository, videoRepository: videoRepository));

  // ##################### uncomment for Admob ########################
  // runApp(Provider.value(
  //     value: adState,
  //     builder: (context, child) => MyApp(
  //           photoRepository: photoRepository,
  //           videoRepository: videoRepository,
  //         )));
}

class MyApp extends StatefulWidget {
  final PhotoRepository photoRepository;
  final VideoRepository videoRepository;

  MyApp({required this.photoRepository, required this.videoRepository});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _storagePermissionCheck;
  Future<int>? _readwritePermissionChecker;

  Future checkStoragePermission() async {
    bool result = await SuperEasyPermissions.isGranted(Permissions.storage);

    print("Checking Read Permission : " + result.toString());
    setState(() {
      _storagePermissionCheck = true;
    });
    return result;
  }

  Future<int> requestStoragePermission() async {
    bool result = await SuperEasyPermissions.askPermission(Permissions.storage);
    if (result) {
      return 1;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    UnityAds.init(gameId: AdStateUnity.gameId, testMode: true);

    _readwritePermissionChecker = (() async {
      int storagePermissionCheckInt;
      int finalPermission;

      print("Initial Values of $_storagePermissionCheck");
      if (_storagePermissionCheck == null || _storagePermissionCheck == false) {
        _storagePermissionCheck = await checkStoragePermission();
      } else {
        _storagePermissionCheck = true;
      }
      if (_storagePermissionCheck!) {
        storagePermissionCheckInt = 1;
      } else {
        storagePermissionCheckInt = 0;
      }

      if (storagePermissionCheckInt == 1) {
        finalPermission = 1;
      } else {
        finalPermission = 0;
      }
      return finalPermission;
    })();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 672),
        builder: (_) {
          return MaterialApp(
            title: 'Status Viewer',
            theme: basicTheme(),
            debugShowCheckedModeBanner: false,
            home: FutureBuilder(
              future: _readwritePermissionChecker,
              builder: (context, status) {
                if (status.connectionState == ConnectionState.done) {
                  if (status.hasData) {
                    if (status.data == 1) {
                      return const Home();
                    } else {
                      return Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(ItemSize.radius(20)),
                                child: Text(
                                  "Read/Write Permission Required",
                                  style: TextStyle(
                                      fontSize: ItemSize.fontSize(20)),
                                ),
                              ),
                              FlatButton(
                                padding: EdgeInsets.all(ItemSize.radius(15)),
                                child: Text(
                                  "Allow read/write Permission",
                                  style: TextStyle(
                                      fontSize: ItemSize.fontSize(20)),
                                ),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ItemSize.radius(50))),
                                onPressed: () {
                                  setState(() {
                                    _readwritePermissionChecker =
                                        requestStoragePermission();
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  } else {
                    return Scaffold(
                      body: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.lightBlue[100]!,
                            Colors.lightBlue[200]!,
                            Colors.lightBlue[300]!,
                            Colors.lightBlue[200]!,
                            Colors.lightBlue[100]!,
                          ],
                        )),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(ItemSize.radius(20)),
                                child: Text(
                                  "Something went wrong.. Please uninstall and Install Again.",
                                  style: TextStyle(
                                      fontSize: ItemSize.fontSize(20)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
            routes: <String, WidgetBuilder>{
              "/home": (BuildContext context) => Home(),
              "/photos": (BuildContext context) => PhotoView(),
              "/videos": (BuildContext context) => VideoListView(),
              // "/aboutus": (BuildContext context) => AboutScreen(),
            },
          );
        });
  }
}
