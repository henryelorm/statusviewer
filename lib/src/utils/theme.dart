import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData basicTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
      headline1:
          base.headline1!.copyWith(fontFamily: 'Montserrat', fontSize: 27.0),
      headline2: base.headline2!.copyWith(
        fontFamily: 'ProximaNova',
        fontSize: 16.0,
      ),
      subtitle1: base.subtitle1!.copyWith(
        fontFamily: 'ProximaNova',
        fontSize: 16.0,
      ),
      headline3: base.headline3!.copyWith(
        fontFamily: 'ProximaNova',
        fontSize: 14.0,
      ),
      subtitle2: base.subtitle2!.copyWith(
        fontFamily: 'ProximaNova',
        fontSize: 14.0,
      ),
      button: base.button!.copyWith(
        fontFamily: 'ProximaNova',
        fontSize: 14.0,
      ),
      bodyText1: base.bodyText1!.copyWith(
        fontFamily: 'ProximaNova',
        fontSize: 12.0,
      ),
      bodyText2: base.bodyText2!.copyWith(
        fontFamily: 'ProximaNova',
        fontSize: 10.0,
      ),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
      accentColor: const Color(0xff1F8F51),
      textTheme: _basicTextTheme(base.textTheme),
      primaryColor: const Color(0xff1F8F51),
      primaryColorDark: const Color(0xff1F8F51),
      colorScheme: const ColorScheme.light(
        primary: Color(0xff1F8F51),
      ));
}

class ItemSize {
  static double fontSize(double value) {
    return value.sp;
  }

  static double iconSize(double value) {
    return value.r;
  }

  static double spaceHeight(double value) {
    return value.h;
  }

  static double radius(double value) {
    return value.r;
  }

  static double spaceWidth(double value) {
    return value.w;
  }
}
