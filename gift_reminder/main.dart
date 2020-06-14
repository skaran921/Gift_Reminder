import 'package:flutter/material.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Gift.prefs = await SharedPreferences.getInstance();
  runApp(GiftApp());
}
