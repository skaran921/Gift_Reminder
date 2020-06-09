import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/bloc/state.dart';
import 'package:gift_reminder/components/customText.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:gift_reminder/dashboard/dashboard.dart';

class DashoboardScreen extends StatefulWidget {
  final GiftAppBloc _giftAppBloc;

  const DashoboardScreen({Key key, GiftAppBloc giftAppBloc})
      : this._giftAppBloc = giftAppBloc,
        super(key: key);
  @override
  _DashoboardScreenState createState() => _DashoboardScreenState(_giftAppBloc);
}

class _DashoboardScreenState extends State<DashoboardScreen> {
  final GiftAppBloc _giftAppBloc;

  _DashoboardScreenState(this._giftAppBloc);

  @override
  void initState() {
    super.initState();
    var adminPrefs = json.decode(Gift.prefs.get(Gift.loginTokenPref));
    AdminToken.adminId = int.parse(adminPrefs["adminId"]);
    AdminToken.adminFirstName = adminPrefs["adminFirstName"];
    AdminToken.adminLastName = adminPrefs["adminLastName"];
    AdminToken.adminEmail = adminPrefs["adminEmail"];
    AdminToken.adminCreateDate = adminPrefs["adminCreateDate"];
    AdminToken.adminUpdateDate = adminPrefs["adminUpdateDate"];
    AdminToken.adminStatus = adminPrefs["adminStatus"];
    GiftAppBloc().dispatch(DashboardPageLoadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GiftAppBloc, GiftAppState>(
        bloc: _giftAppBloc,
        builder: (context, currentState) {
          if (currentState is UnGiftAppState) {
            return Column(
              children: [
                ListTileShimmer(
                  isDisabledButton: true,
                ),
                ListTileShimmer(
                  isDisabledButton: true,
                ),
                ListTileShimmer(
                  isDisabledButton: true,
                ),
                ListTileShimmer(
                  isDisabledButton: true,
                )
              ],
            );
          }

          if (widget._giftAppBloc.hasDashBoardPageError) {
            return Center(
              child: CustomText(
                  text: "${widget._giftAppBloc.dashboardPageErrorString}"),
            );
          }

          return DashBoard();
        });
  }
}
