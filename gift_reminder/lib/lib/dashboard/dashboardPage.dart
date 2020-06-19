import 'package:flutter/material.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/dashboard/dashboardScreen.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _giftAppBloc = GiftAppBloc();
    return SafeArea(
        child: DashoboardScreen(
      giftAppBloc: _giftAppBloc,
    ));
  }
}
