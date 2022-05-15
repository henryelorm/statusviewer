// preload all svg images b4 pages loads
import 'package:flutter_svg/flutter_svg.dart';
import 'package:statusviewer/src/utils/constants.dart';

Future preCacheSvgs() async {
  Future.wait([
    precachePicture(
      ExactAssetPicture(
          SvgPicture.svgStringDecoderBuilder, ConstantImages.menuIconPath),
      null,
    ),
    // other SVGs or images here
  ]);
}
