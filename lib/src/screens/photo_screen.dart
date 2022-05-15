import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:statusviewer/src/bloc/photo_bloc/photo_bloc.dart';
import 'package:statusviewer/src/components/ad_state.dart';
import 'package:statusviewer/src/data/enums/custom_response.dart';
import 'package:statusviewer/src/utils/responsive/base_widget.dart';
import 'package:statusviewer/src/utils/theme.dart';
import 'package:statusviewer/src/widgets/common_widgets.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class PhotoView extends StatefulWidget {
  @override
  PhotoViewState createState() {
    return PhotoViewState();
  }
}

class PhotoViewState extends State<PhotoView> {
  //##################### uncomment for Add ########################
  final _inlineAdIndex = 3;

  // late BannerAd _bottomBannerAd;
  // late BannerAd _inlineBannerAd;

  late UnityBannerAd _unityFooterBannerAd;
  late UnityBannerAd _unityInlineBannerAd;

  bool _isBottomBannerAdLoaded = false;
  bool _isInlineBannerAdLoaded = false;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final PhotoBloc? _photoBloc = PhotoBloc();

  @override
  void initState() {
    super.initState();
    _photoBloc!.fetchPhotos();
  }

  //##################### uncomment for Add ########################
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _createUnityFooterBannerAd();
    _createUnityInlineBannerAd();
    // final adState = Provider.of<AdState>(context);
    // adState.initialization.then((status) {
    //   setState(() {
    //     _createBottomBannerAd(adState);
    //     _createInlineBannerAd(adState);
    //   });
    // });
  }

  void _createUnityFooterBannerAd() {
    print("####################   nabs");
    _unityFooterBannerAd = UnityBannerAd(
      size: BannerSize(width: 20, height: 10),
      placementId: AdStateUnity.photoFooterBannerAdUnitId,
      onLoad: (_) {
        setState(() {
          print("******************************");
          _isBottomBannerAdLoaded = true;
        });
      },
      onFailed: (_, UnityAdsBannerError err, __) {
        setState(() {
          setState(() {
            // _isBottomBannerAdLoaded = false;
          });
        });
      },
    );
  }

  void _createUnityInlineBannerAd() {
    _unityFooterBannerAd = UnityBannerAd(
      size: BannerSize.leaderboard,
      placementId: AdStateUnity.photoInlineBannerAdUnitId,
      onLoad: (_) {
        setState(() {
          _isInlineBannerAdLoaded = true;
        });
      },
      onFailed: (_, UnityAdsBannerError err, __) {
        setState(() {
          setState(() {
            _isInlineBannerAdLoaded = false;
          });
        });
      },
    );
  }

  // ############  Admob
  // void _createBottomBannerAd(AdState adState) {
  //   _bottomBannerAd = BannerAd(
  //       size: AdSize.banner,
  //       adUnitId: adState.photoBottomBannerAdUnitId,
  //       request: const AdRequest(),
  //       listener: BannerAdListener(
  //         onAdLoaded: (ad) => setState(() {
  //           _isBottomBannerAdLoaded = true;
  //         }),
  //         onAdFailedToLoad: (ad, error) => ad.dispose(),
  //       ))
  //     ..load();
  // }

  int _getListViewItemIndex(int index) {
    if (index >= _inlineAdIndex && _isInlineBannerAdLoaded) {
      return index - 1;
    }
    return index;
  }

  // void _createInlineBannerAd(AdState adState) {
  //   _inlineBannerAd = BannerAd(
  //       size: AdSize.mediumRectangle,
  //       adUnitId: adState.photoInlineBannerAdUnitId,
  //       request: const AdRequest(),
  //       listener: BannerAdListener(
  //         onAdLoaded: (ad) => setState(() {
  //           _isInlineBannerAdLoaded = true;
  //         }),
  //         onAdFailedToLoad: (ad, error) => ad.dispose(),
  //       ))
  //     ..load();
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _bottomBannerAd.dispose();
    // _inlineBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = max(size.height * .05, 50.0);

    //##################### uncomment for Add ########################
    // final adState = Provider.of<AdState>(context);

    return Scaffold(
        // persistentFooterButtons: [],
        body: ResponsiveUi(builder: (context, sizingInformation) {
      return StreamBuilder<Response>(
          stream: _photoBloc!.statusStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case Status.LOADING:
                  return const Center(child: CircularProgressIndicator());

                case Status.ERROR:
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: ItemSize.spaceWidth(10)),
                    child: EmptyErrorView(
                        height: height,
                        size: size,
                        scaffoldState: scaffoldState,
                        text: const Text(
                          "Error! \n Please make sure WhatsApp is Installed on your device",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black87, fontSize: 16),
                        )),
                  );
                case Status.COMPLETED:
                  return StreamBuilder<List>(
                    stream: _photoBloc!.photoStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Stack(
                          children: [
                            StaggeredGridView.countBuilder(
                                padding: EdgeInsets.fromLTRB(
                                    ItemSize.spaceWidth(4),
                                    ItemSize.spaceHeight(14),
                                    ItemSize.spaceWidth(4),
                                    ItemSize.spaceHeight(14)),
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 12,
                                itemCount: snapshot.data!.length +
                                    (_isInlineBannerAdLoaded ? 1 : 0),
                                itemBuilder: (context, index) {
                                  //##################### uncomment for Add ########################
                                  if (_isInlineBannerAdLoaded &&
                                      index == _inlineAdIndex) {
                                    return PhotoGrid(
                                      imgPath: '',
                                      isAd: true,
                                      adWidget: UnityBannerAd(
                                        size: BannerSize.iabStandard,
                                        placementId: AdStateUnity
                                            .photoInlineBannerAdUnitId,
                                        onLoad: (_) {
                                          _isInlineBannerAdLoaded = true;
                                        },
                                      ),
                                      // adWidget: UnityBannerAd
                                      //     AdWidget(ad: _inlineBannerAd)
                                    );
                                  } else {
                                    return PhotoGrid(
                                        imgPath: snapshot.data![
                                            _getListViewItemIndex(index)]);
                                  }
                                },
                                staggeredTileBuilder: (index) {
                                  return StaggeredTile.count(
                                      1, index.isEven ? 1 : 1.25);
                                }),

                            //################# uncomment for ad session #######
                            // if (!_isBottomBannerAdLoaded)
                            //   const SizedBox(
                            //     height: 30,
                            //   )
                            // else
                            Positioned(
                              bottom: 4,
                              child: _unityFooterBannerAd,
                            ),
                          ],
                        );
                      } else {
                        return Center(
                            heightFactor: 13,
                            child: emptyListNotice(
                                context: context,
                                emptyListText: "No images found"));
                      }
                    },
                  );
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    }));
  }
}
