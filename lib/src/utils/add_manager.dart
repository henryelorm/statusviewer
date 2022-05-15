




// import 'dart:io';
//
// import 'package:admob_flutter/admob_flutter.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:statusviewer/src/widgets/common_widgets.dart';
//
// class AdManager {
//   static String? getBannerAdUnitIdPhoto() {
//     if (Platform.isIOS) {
//       return '';
//     } else if (Platform.isAndroid) {
//       return 'ca-app-pub-4395920285910847/7080275796';
//     }
//     return null;
//   }
//
//   static String? getBannerAdUnitIdVideo() {
//     if (Platform.isIOS) {
//       return '';
//     } else if (Platform.isAndroid) {
//       return 'ca-app-pub-4395920285910847/5575622434';
//     }
//     return null;
//   }
//
//   static String? getInterstitialAdUnitId() {
//     if (Platform.isIOS) {
//       return '';
//     } else if (Platform.isAndroid) {
//       return 'ca-app-pub-4395920285910847/5708496136';
//     }
//     return null;
//   }
//
//   static String? getRewardBasedVideoAdUnitId() {
//     if (Platform.isIOS) {
//       return '';
//     } else if (Platform.isAndroid) {
//       return '';
//     }
//     return null;
//   }
//
//   static void handleEvent(
//       {GlobalKey<ScaffoldState>? scaffoldState,
//         AdmobAdEvent? event,
//         Map<String, dynamic>? args,
//         String? adType}) {
//     switch (event) {
//       case AdmobAdEvent.loaded:
//         showSnackBar(
//             scaffoldState: scaffoldState,
//             content: 'New Admob $adType Ad loaded!');
//         break;
//       case AdmobAdEvent.opened:
//         showSnackBar(
//             scaffoldState: scaffoldState, content: 'Admob $adType Ad opened!');
//         break;
//       case AdmobAdEvent.closed:
//         showSnackBar(
//             scaffoldState: scaffoldState, content: 'Admob $adType Ad closed!');
//         break;
//       case AdmobAdEvent.failedToLoad:
//         showSnackBar(
//             scaffoldState: scaffoldState,
//             content: 'Admob $adType failed to load. :(');
//         break;
//       case AdmobAdEvent.rewarded:
//         showDialog(
//           context: scaffoldState!.currentContext!,
//           builder: (BuildContext context) {
//             return WillPopScope(
//               child: AlertDialog(
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Text('Reward callback fired. Thanks Andrew!'),
//                     Text('Type: ${args['type']}'),
//                     Text('Amount: ${args['amount']}'),
//                   ],
//                 ),
//               ),
//               onWillPop: () async {
//                 scaffoldState.currentState.hideCurrentSnackBar();
//                 return true;
//               },
//             );
//           },
//         );
//         break;
//       default:
//     }
//   }
// }
