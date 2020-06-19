import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/bloc/state.dart';
import 'package:gift_reminder/components/customText.dart';
import 'package:gift_reminder/components/custonAlertBox.dart';
import 'package:gift_reminder/components/drawe.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:gift_reminder/dashboard/book/books.dart';
import 'package:gift_reminder/dashboard/dashboard.dart';
import 'package:gift_reminder/dashboard/profile/profile.dart';
import 'package:gift_reminder/dashboard/search/custom_search.dart';
import 'package:gift_reminder/dashboard/transaction/addTransaction.dart';
import 'package:gift_reminder/login/login.dart';

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
            return Scaffold(
              appBar: AppBar(
                title: Text("Gift Reminder"),
              ),
              body: SingleChildScrollView(
                child: Column(
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
                ),
              ),
            );
          }

          if (widget._giftAppBloc.hasDashBoardPageError) {
            return Scaffold(
              body: Center(
                child: CustomText(
                    text: "${widget._giftAppBloc.dashboardPageErrorString}"),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              centerTitle: true,
              title: Text("Dashboard"),
              actions: [
                DropdownButton(
                  underline: Container(),
                  items: [
                    DropdownMenuItem(
                      value: "logout",
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FontAwesomeIcons.signOutAlt),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "Logout",
                            style: TextStyle(
                                color: Theme.of(context).textTheme.body2.color),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "customSearch",
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FontAwesomeIcons.searchengin),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "Search",
                            style: TextStyle(
                                color: Theme.of(context).textTheme.body2.color),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Profile",
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FontAwesomeIcons.userCircle),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "Profile",
                            style: TextStyle(
                                color: Theme.of(context).textTheme.body2.color),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: "Books",
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(FontAwesomeIcons.book),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            "Books",
                            style: TextStyle(
                                color: Theme.of(context).textTheme.body2.color),
                          ),
                        ],
                      ),
                    )
                  ],
                  icon: Icon(
                    Icons.more_vert,
                    color: Color(0xFFebebeb),
                  ),
                  onChanged: (value) {
                    if (value == "Profile") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => Profile()));
                    } else if (value == "logout") {
                      CustomAlertBox.showConfirmBox(
                          context: context,
                          title: "Logout",
                          content: Text("Are you sure you want to logout?"),
                          onSure: () {
                            Gift.prefs.clear();

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          });
                    } else if (value == "customSearch") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CustomSearch()));
                    } else if (value == "Books") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Books()));
                    }
                  },
                ),
                SizedBox(
                  width: 10.0,
                )
              ],
            ),
            body: DashBoard(),
            drawer: MyDrawer(),
            floatingActionButton: FloatingActionButton(
              heroTag: "addBtn",
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTransaction(
                              giftAppBloc: _giftAppBloc,
                            )));
              },
            ),
          );
        });
  }
}
