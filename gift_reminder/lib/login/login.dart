import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:gift_reminder/create_account/create_account.dart';
import 'package:gift_reminder/create_account/forgot_password.dart';
import 'package:gift_reminder/dashboard/dashboardPage.dart';
import 'package:gift_reminder/service/login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  Future _onLogin() async {
    GiftAppBloc().dispatch(LoginLoadingEvent(true));
    FocusScope.of(context).unfocus();
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      await LoginService.authenticate(
              email: _emailController.text, password: _passwordController.text)
          .then((value) {
        if (value['error'] == "X") {
          GiftAppBloc().dispatch(SetLoginErrorEvent("${value['msg']}"));
        } else {
          // authenticated user
          AdminToken.adminId = value['result']["ADMIN_ID"];
          AdminToken.adminFirstName = value['result']["ADMIN_FIRST_NAME"];
          AdminToken.adminLastName = value['result']["ADMIN_LAST_NAME"];
          AdminToken.adminEmail = value['result']["ADMIN_EMAIL"];
          AdminToken.adminCreateDate = value['result']["ADMIN_CREATE_DATE"];
          AdminToken.adminUpdateDate = value['result']["ADMIN_UPDATE_DATE"];
          AdminToken.adminStatus = value['result']["ADMIN_STATUS"];
          var _loginToken =
              '{"adminId":"${AdminToken.adminId}","adminFirstName":"${AdminToken.adminFirstName}","adminLastName":"${AdminToken.adminLastName}","adminEmail":"${AdminToken.adminEmail}","adminCreateDate":"${AdminToken.adminCreateDate}","adminUpdateDate":"${AdminToken.adminUpdateDate}","adminStatus":"${AdminToken.adminStatus}","tokenCreateDate":"${DateTime.now()}","tockenExpiryDate": "${DateTime.now().add(Duration(days: 7))}"}';
          Gift.prefs.setString(Gift.loginTokenPref, _loginToken);
          GiftAppBloc().dispatch(SetLoginEvent(true));
          GiftAppBloc().dispatch(SetLoginErrorEvent(""));
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DashboardPage()));
        }
      });
    }
    GiftAppBloc().dispatch(LoginLoadingEvent(false));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 22,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60.0,
                      backgroundImage: AssetImage("assets/images/gift.png"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Gift Reminder",
                      style: TextStyle(
                          fontSize: 30.0,
                          color: Theme.of(context).textTheme.body2.color),
                    ),
                  ],
                ),
              )),
              Container(
                padding: EdgeInsets.only(
                    top: 0.0, left: 30.0, right: 30.0, bottom: 20.0),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      GiftAppBloc().loginError.isEmpty
                          ? Container()
                          : Container(
                              margin: EdgeInsets.only(bottom: 4.0),
                              padding: EdgeInsets.all(6.0),
                              color: Theme.of(context).errorColor,
                              child: Text(
                                "${GiftAppBloc().loginError}",
                                style: TextStyle(color: Color(0xFFfefefe)),
                              ),
                            ),
                      Row(
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Theme.of(context).textTheme.body2.color),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          GiftAppBloc().isLoginLoading
                              ? CircularProgressIndicator()
                              : Container()
                        ],
                      ),
                      TextFormField(
                        controller: _emailController,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: "Email",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Email Required";
                          }

                          if (!value.contains('@')) {
                            return "Email is not valid";
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        autocorrect: false,
                        decoration: InputDecoration(labelText: "Password"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Password Required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton.icon(
                        disabledColor: Colors.indigo[100],
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        color: Theme.of(context).primaryColor,
                        icon: Icon(
                          FontAwesomeIcons.signInAlt,
                          color: Color(0xFFebebeb),
                        ),
                        label: Text(
                          "Login",
                          style: TextStyle(
                              color: Color(0xFFebebeb), fontSize: 20.0),
                        ),
                        onPressed:
                            GiftAppBloc().isLoginLoading ? null : _onLogin,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      FlatButton.icon(
                          disabledColor: Colors.indigo[100],
                          onPressed: GiftAppBloc().isLoginLoading
                              ? null
                              : () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreateAccount()));
                                },
                          icon: Icon(
                            Icons.add_circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          label: Text(
                            "Create Account",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                      FlatButton.icon(
                          disabledColor: Colors.indigo[100],
                          onPressed: GiftAppBloc().isLoginLoading
                              ? null
                              : () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()));
                                },
                          icon: Icon(
                            Icons.lock_open,
                            color: Theme.of(context).primaryColor,
                          ),
                          label: Text(
                            "Forgot you password? tap here",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
