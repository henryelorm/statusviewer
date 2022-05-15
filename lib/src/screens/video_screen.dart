import 'dart:math';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:statusviewer/src/bloc/video_bloc/video_bloc.dart';
import 'package:statusviewer/src/components/ad_state.dart';
import 'package:statusviewer/src/data/enums/custom_response.dart';
import 'package:statusviewer/src/utils/responsive/base_widget.dart';
import 'package:statusviewer/src/utils/theme.dart';
import 'package:statusviewer/src/widgets/common_widgets.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class VideoListView extends StatefulWidget {
  @override
  VideoListViewState createState() {
    return new VideoListViewState();
  }
}

class VideoListViewState extends State {
  final _inlineAdIndex = 3;

  // late BannerAd _bottomBannerAd;
  // late BannerAd _inlineBannerAd;

  bool _isBottomBannerAdLoaded = false;
  bool _isInlineBannerAdLoaded = false;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final VideoBloc? _videoBloc = VideoBloc();

  @override
  void initState() {
    super.initState();
    _videoBloc!.fetchVideos();
  }

  //##################### uncomment for Add ########################
  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   final adState = Provider.of<AdState>(context);
  //   adState.initialization.then((status) {
  //     setState(() {
  //       _createBottomBannerAd(adState);
  //       _createInlineBannerAd(adState);
  //     });
  //   });
  // }

  // void _createBottomBannerAd(AdState adState) {
  //   _bottomBannerAd = BannerAd(
  //       size: AdSize.banner,
  //       adUnitId: adState.videoBottomBannerAdUnitId,
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
  //       adUnitId: adState.videoInlineBannerAdUnitId,
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
    final orientation = MediaQuery.of(context).orientation;

    //##################### uncomment for Add ########################
    // final adState = Provider.of<AdState>(context);

    return Scaffold(body: ResponsiveUi(builder: (context, sizingInformation) {
      return StreamBuilder<Response>(
          stream: _videoBloc!.statusStream,
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
                    stream: _videoBloc!.videoStream,
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
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return VideoGrid(
                                      imgPath: snapshot.data![index]);
                                },
                                staggeredTileBuilder: (index) {
                                  return StaggeredTile.count(
                                      1, index.isEven ? 1 : 1.25);
                                }),
                            //################# uncomment for ad session #######
                            if (!_isBottomBannerAdLoaded)
                              const SizedBox(
                                height: 30,
                              )
                            else
                              Positioned(
                                bottom: 4,
                                child: SizedBox(
                                  height: height,
                                  width: size.width,
                                  child: UnityBannerAd(
                                      placementId: AdStateUnity
                                          .videoFooterBannerAdUnitId),
                                  // child: AdWidget(ad: _bottomBannerAd),
                                ),
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
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    }));
  }
}
