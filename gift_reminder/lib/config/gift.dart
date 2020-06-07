import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class Gift {
  // api
  static const String baseUrl = "http://192.168.43.240/MyGift/api";

  // texts

  // colors
  static const Color indigoColor = Color(0xFF4012d0);
  static const Color lightIndigoColor = Color(0xFF5425e7);
  static const Color blueColor = Color(0xFF0362ff);
  static const Color lightBlueColor = Color(0xFF008bff);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color lightWhiteColor = Color(0xFFFAFAFA);
  static const Color orangeColor = Color(0xFFFFC10C);
  static const Color skyBlueColor = Color(0xFF00CAFF);
  static const Color greyColor = Color(0xe6e8ef);
  static const Color lightRedColor = Color(0xF97B96);
  // fontFamily

  // sharedPrefs

  static SharedPreferences prefs;
  // * darkmode key
  static const String darkModePref = "darkModePref";

  // * userLogin key
  static const String loginTokenPref = "loginTokenPref";
}
