import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/bloc/state.dart';
import 'package:gift_reminder/dashboard/dashboardPage.dart';
import 'package:gift_reminder/login/login.dart';

class GiftApp extends StatefulWidget {
  @override
  _GiftAppState createState() => _GiftAppState();
}

class _GiftAppState extends State<GiftApp> {
  GiftAppBloc _giftAppBloc;

  @override
  void initState() {
    super.initState();
    // Gift.prefs.clear();
    _giftAppBloc = GiftAppBloc();
    GiftAppBloc().dispatch(LoadingGiftAppEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GiftAppBloc>(
      builder: (context) => _giftAppBloc,
      child: BlocBuilder<GiftAppBloc, GiftAppState>(
        bloc: _giftAppBloc,
        builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: _giftAppBloc.isDarkMode
                  ? ThemeData.dark()
                  : ThemeData(
                      primaryColor: Color(0xFF390ac8),
                      scaffoldBackgroundColor: Color(0xfffcfcfc),
                      accentColor: Color(0xAA390ac8),
                      iconTheme: IconThemeData(color: Color(0xFFABA7C0)),
                      fontFamily: "Poppins",
                      buttonTheme: ButtonThemeData(
                          buttonColor: Color(0xFF390ac8),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.0))),
                          textTheme: ButtonTextTheme.primary),
                      textTheme: TextTheme(
                          bodyText2: TextStyle(color: Color(0xFFABA7C0))),
                      appBarTheme: AppBarTheme(
                          color: Color(0xFF4f21d2),
                          actionsIconTheme:
                              IconThemeData(color: Color(0xFFebebeb)))),
              home: GiftAppBloc().isLogin ? DashboardPage() : LoginScreen());
        },
      ),
    );
  }
}
