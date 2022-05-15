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
import 'package:statusviewer/src/utils/theme.dart';
import 'package:statusviewer/src/widgets/common_widgets.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

const int maxFailedLoadAttempts = 3;

class ViewPhoto extends StatefulWidget {
  final String imgPath;

  ViewPhoto({required this.imgPath});

  @override
  _ViewPhotoState createState() => _ViewPhotoState();
}

class _ViewPhotoState extends State<ViewPhoto> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  int _interstitialLoadAttempts = 0;

  // InterstitialAd? _interstitialAd;
  //
  // AdState? _adState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _adState = Provider.of<AdState>(context, listen: false);
    // _createInterstitialAd(_adState!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _interstitialAd?.dispose();
  }

  // void _createInterstitialAd(AdState adState) {
  //   InterstitialAd.load(
  //       adUnitId: adState.photoInterstitialAdUnit,
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

  final LinearGradient backgroundGradient = const LinearGradient(
    colors: [
      Color(0x00000000),
      Color(0x00333333),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  void _onLoading(bool t, String str, BuildContext context) {
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
                if (widget.imgPath != null) {
                  Share.shareFiles([widget.imgPath]);
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
                _onLoading(true, "", context);

                await Future.delayed(const Duration(seconds: 2))
                    .then((value) async {
                  await GallerySaver.saveImage(widget.imgPath).then((value) {
                    // _showInterstitialAd(_adState!);
                    UnityAds.showVideoAd(placementId: 'Interstitial_Android');
                    _onLoading(false, "", context);
                  }).onError((error, stackTrace) {
                    _onLoading(
                        false,
                        "If Image is not available in gallary\n\nYou can find all images at downloads",
                        context);
                  });
                });
              }),
        ],
        leading: IconButton(
          color: Colors.indigo,
          iconSize: ItemSize.fontSize(24),
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Hero(
                tag: widget.imgPath,
                child: Image.file(
                  File(widget.imgPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //     backgroundColor: Theme.of(context).primaryColor,
      //     child: Icon(
      //       Icons.file_download,
      //       color: Colors.white,
      //     ),
      //     onPressed: () async {}),
    );
  }
}
