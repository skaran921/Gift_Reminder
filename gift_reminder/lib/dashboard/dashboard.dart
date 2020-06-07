import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/dashboard/addTransaction.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.dashboard),
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
                          color: Theme.of(context).textTheme.bodyText2.color),
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
                          color: Theme.of(context).textTheme.bodyText2.color),
                    ),
                  ],
                ),
              )
            ],
            icon: Icon(
              Icons.more_vert,
              color: Color(0xFFebebeb),
            ),
            onChanged: (value) {},
          ),
          SizedBox(
            width: 10.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTransaction()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
