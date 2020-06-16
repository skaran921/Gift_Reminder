import 'package:flutter/material.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/service/profile.dart';
import 'package:lottie/lottie.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _changePasswordFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<bool> _onWillPop() async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Confirmation"),
              content: Text("Are you sure you want to leave this page?"),
              actions: [
                FlatButton.icon(
                    color: Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    icon: Icon(Icons.close),
                    label: Text('Close')),
                FlatButton.icon(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: Icon(Icons.check),
                    label: Text('Sure'))
              ],
            ));
  }

  Future _onSubmit(BuildContext ctx) async {
    FocusScope.of(context).unfocus();
    if (_changePasswordFormKey.currentState.validate()) {
      _changePasswordFormKey.currentState.save();

      await ProfileService.updatePassword(
              adminId: AdminToken.adminId,
              email: AdminToken.adminEmail,
              password: _currentPasswordController.text,
              newPassword: _newPasswordController.text)
          .then((value) async {
        if (value['error'] == "X") {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Row(
              children: [
                Lottie.asset(
                  "assets/images/lottie/error-animation.json",
                  width: 30.0,
                  height: 30.0,
                  fit: BoxFit.fill,
                ),
                Text("${value['msg']}"),
              ],
            ),
            backgroundColor: Theme.of(ctx).errorColor,
          ));
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  "assets/images/lottie/success.json",
                  width: 30.0,
                  height: 30.0,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  width: 4.0,
                ),
                Expanded(
                  child: Text(
                    "${value["msg"]}",
                  ),
                )
              ],
            ),
            backgroundColor: Theme.of(ctx).primaryColor,
          ));
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        }
      });
    } else {
      // show alert
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Row(
          children: [
            Lottie.asset(
              "assets/images/lottie/error-animation.json",
              width: 30.0,
              height: 30.0,
              fit: BoxFit.fill,
            ),
            Text("Please fill required fields"),
          ],
        ),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Change Password"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12.0),
          child: Container(
            child: Card(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                child: Form(
                  key: _changePasswordFormKey,
                  onWillPop: _onWillPop,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/forgot_password.png",
                        width: 200,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: "Current Password"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Current Password Required";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(labelText: "New Password"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "New Password Required";
                          } else if (value.length < 8) {
                            return "New Password Must Contains At Least 8 Characters";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: "Confirm Password"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Confirm Password Required";
                          } else if (value != _newPasswordController.text) {
                            return "Confirm Password Are Incorrect";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      FlatButton(
                        child: Text("Change Password"),
                        onPressed: () {
                          _onSubmit(context);
                        },
                        color: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
