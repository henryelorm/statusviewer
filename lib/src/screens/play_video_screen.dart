import 'dart:io';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:statusviewer/src/components/ad_state.dart';
import 'package:statusviewer/src/components/video_controller.dart';
import 'package:statusviewer/src/utils/theme.dart';
import 'package:statusviewer/src/widgets/admob_widgets.dart';
import 'package:statusviewer/src/widgets/common_widgets.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:video_player/video_player.dart';

const int maxFailedLoadAttempts = 3;

class PlayStatusVideo extends StatefulWidget {
  final String videoFile;

  PlayStatusVideo(this.videoFile);

  @override
  _PlayStatusVideoState createState() => _PlayStatusVideoState();
}

class _PlayStatusVideoState extends State<PlayStatusVideo> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  int _interstitialLoadAttempts = 0;

  // InterstitialAd? _interstitialAd;

  // AdState? _adState;

  @override
  void initState() {
    super.initState();
    // _adState = Provider.of<AdState>(context, listen: false);
    // _createInterstitialAd(_adState!);
  }

  // void _createInterstitialAd(AdState adState) {
  //   InterstitialAd.load(
  //       adUnitId: adState.videoInterstitialAdUnit,
  //       request: const AdRequest(),
  //       adLoadCallback:
  //           InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
  //         _interstitialAd = ad;
  //         _interstitialLoadAttempts = 0;
  //       }, onAdFailedToLoad: (LoadAdError error) {
  //         _interstitialLoadAttempts += 1;
  //         _interstitialAd = null;
  //         if (_interstitialLoadAttempts >= maxFailedLoadAttempts) {
  //           _createInterstitialAd(adState);
  //         }
  //       }));
  // }
  //
  // void _showInterstitialAd(AdState adState) {
  //   if (_interstitialAd != null) {
  //     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //         onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       ad.dispose();
  //       _createInterstitialAd(adState);
  //     }, onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError er) {
  //       ad.dispose();
  //       _createInterstitialAd(adState);
  //     });
  //     _interstitialAd!.show();
  //   }
  // }

  void dispose() {
    super.dispose();
  }

  void _onLoading(bool t, String str) {
    if (t) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                Center(
                  child: Container(
                      padding: EdgeInsets.all(ItemSize.radius(10)),
                      child: const CircularProgressIndicator()),
                ),
              ],
            );
          });
    } else {
      Navigator.pop(context);
      successSnackBar(
          context: context, message: "Download successful: Saved to Gallery");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              icon: Icon(
                Icons.share_sharp,
                size: ItemSize.fontSize(25),
                color: Colors.black87,
              ),
              onPressed: () async {
                if (widget.videoFile != null) {
                  Share.shareFiles([widget.videoFile]);
                  UnityAds.showVideoAd(placementId: 'Interstitial_Android');
                  // _showInterstitialAd(_adState!);
                } else {
                  errorSnackBar(context: context, message: "File not found");
                }
              }),
          IconButton(
              icon: Icon(
                Icons.file_download,
                size: ItemSize.fontSize(28),
                color: Colors.black87,
              ),
              onPressed: () async {
                _onLoading(true, "");
                await Future.delayed(const Duration(seconds: 2))
                    .then((value) async {
                  await GallerySaver.saveVideo(widget.videoFile).then((value) {
                    UnityAds.showVideoAd(placementId: 'Interstitial_Android');
                    // _showInterstitialAd(_adState!);
                    _onLoading(false, "");
                  }).onError((error, stackTrace) {
                    _onLoading(
                      false,
                      "If Video not available in gallary\n\nYou can find all videos at downloads",
                    );
                  });
                });
                // if (await interstitialAd.isLoaded) {
                //   interstitialAd.show();
                // } else {}
              })
        ],
        leading: IconButton(
          color: Colors.indigo,
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StatusVideo(
        videoPlayerController:
            VideoPlayerController.file(File(widget.videoFile)),
        looping: true,
        videoSrc: widget.videoFile,
      ),
    );
  }
}
