import 'package:flutter/material.dart';
import 'package:gift_reminder/components/customIcon.dart';
import 'package:gift_reminder/components/customText.dart';
import 'package:gift_reminder/components/custonAlertBox.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:gift_reminder/dashboard/profile/change_password.dart';
import 'package:gift_reminder/dashboard/profile/edit_profile..dart';
import 'package:gift_reminder/dashboard/transaction/searchTransaction.dart';
import 'package:gift_reminder/dashboard/transaction/transactions.dart';
import 'package:gift_reminder/login/login.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(AdminToken.adminEmail),
            accountName: Text(
                "${AdminToken.adminFirstName} ${AdminToken.adminLastName}"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              child: Text(
                "${AdminToken.adminFirstName[0]}${AdminToken.adminLastName == null ? "" : AdminToken.adminLastName[0]}",
                style: TextStyle(fontSize: 38.0),
              ),
            ),
          ),
          ListTile(
            title: CustomText(text: "Search"),
            trailing: CustomIcon(icon: Icons.search),
            onTap: () {
              showSearch(context: context, delegate: SearchTransaction());
            },
          ),
          Divider(
            thickness: 0.3,
            color: Theme.of(context).textTheme.body2.color,
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AllTransactions()));
            },
            title: CustomText(text: "All Transactions"),
            trailing: CustomIcon(icon: Icons.library_books),
          ),
          Divider(
            thickness: 0.3,
            color: Theme.of(context).textTheme.body2.color,
          ),
          ListTile(
            title: CustomText(text: "Add Book"),
            trailing: CustomIcon(icon: Icons.book),
          ),
          Divider(
            thickness: 0.3,
            color: Theme.of(context).textTheme.body2.color,
          ),
          ListTile(
            title: CustomText(text: "Edit Profile"),
            trailing: CustomIcon(icon: Icons.edit),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile()));
            },
          ),
          Divider(
            thickness: 0.3,
            color: Theme.of(context).textTheme.body2.color,
          ),
          ListTile(
            title: CustomText(text: "Change Password"),
            trailing: CustomIcon(icon: Icons.lock),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChangePassword()));
            },
          ),
          Divider(
            thickness: 0.3,
            color: Theme.of(context).textTheme.body2.color,
          ),
          ListTile(
            onTap: () {
              CustomAlertBox.showConfirmBox(
                  context: context,
                  title: "Logout",
                  content: Text("Are you sure you want to logout?"),
                  onSure: () {
                    Gift.prefs.clear();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  });
            },
            title: CustomText(text: "Logout"),
            trailing: CustomIcon(icon: Icons.exit_to_app),
          ),
          ListTile(
            onTap: () {
              CustomAlertBox.showInfoBox(
                  context: context,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                          child: CustomIcon(
                        icon: Icons.info,
                      )),
                      Text("Design and develop by Karan Soni"),
                      Text("v 1.0.0, June 2020")
                    ],
                  ));
            },
            title: CustomText(text: "Version"),
            subtitle: CustomText(text: "1.0.0"),
            leading: CustomIcon(icon: Icons.verified_user),
            trailing: CustomIcon(
              icon: Icons.info,
            ),
          ),
        ],
      ),
    );
  }
}
