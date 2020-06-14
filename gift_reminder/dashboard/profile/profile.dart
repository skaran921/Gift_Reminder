import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/components/customIcon.dart';
import 'package:gift_reminder/components/customText.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/dashboard/profile/edit_profile..dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Column(
            children: [
              Image.asset(
                "assets/images/user.png",
                width: 150,
              ),
              ListTile(
                leading: CustomIcon(
                  icon: Icons.account_circle,
                ),
                title: CustomText(
                  text: "Admin Name",
                ),
                subtitle: CustomText(
                  text:
                      "${AdminToken.adminFirstName} ${AdminToken.adminLastName}",
                ),
                trailing: FloatingActionButton(
                  mini: true,
                  heroTag: "editBtn1",
                  child: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EditProfile()));
                  },
                ),
              ),
              ListTile(
                leading: CustomIcon(
                  icon: Icons.email,
                ),
                title: CustomText(
                  text: "Email",
                ),
                subtitle: CustomText(
                  text: "${AdminToken.adminEmail}",
                ),
              ),
              ListTile(
                leading: CustomIcon(
                  icon: FontAwesomeIcons.calendarAlt,
                ),
                title: CustomText(
                  text: "Account Created At",
                ),
                subtitle: CustomText(
                  text: "${AdminToken.adminCreateDate}",
                ),
              ),
              ListTile(
                leading: CustomIcon(
                  icon: FontAwesomeIcons.calendarPlus,
                ),
                title: CustomText(
                  text: "Account Updated At",
                ),
                subtitle: CustomText(
                  text: "${AdminToken.adminUpdateDate}",
                ),
              ),
              ListTile(
                leading: CustomIcon(
                  icon: Icons.announcement,
                ),
                title: CustomText(
                  text: "Status",
                ),
                subtitle: CustomText(
                  text: "${AdminToken.adminStatus}",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
