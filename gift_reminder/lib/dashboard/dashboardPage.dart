import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/components/custonAlertBox.dart';
import 'package:gift_reminder/components/drawe.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:gift_reminder/dashboard/transaction/addTransaction.dart';
import 'package:gift_reminder/dashboard/dashboardScreen.dart';
import 'package:gift_reminder/dashboard/profile/profile.dart';
import 'package:gift_reminder/login/login.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _giftAppBloc = GiftAppBloc();
    return SafeArea(
      child: Scaffold(
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
                }
              },
            ),
            SizedBox(
              width: 10.0,
            )
          ],
        ),
        body: DashoboardScreen(
          giftAppBloc: _giftAppBloc,
        ),
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
      ),
    );
  }
}
