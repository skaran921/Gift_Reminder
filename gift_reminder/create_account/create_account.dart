import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/login/login.dart';
import 'package:gift_reminder/service/createAccount.dart';
import 'package:lottie/lottie.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _createAccountFormKey = GlobalKey<FormState>();
  final _createAccountScaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _firstNameControlelr = TextEditingController();
  TextEditingController _lastNameControlelr = TextEditingController();
  TextEditingController _emailControlelr = TextEditingController();
  TextEditingController _passwordControlelr = TextEditingController();
  TextEditingController _confirmPasswordControlelr = TextEditingController();

  Future<void> _onCreateAccount() async {
    FocusScope.of(context).unfocus();
    GiftAppBloc().dispatch(IsCreateAccountPageLoadingEvent(true));
    if (_createAccountFormKey.currentState.validate()) {
      _createAccountFormKey.currentState.save();
      await CreateAccountService.createNewAccount(
              firstName: _firstNameControlelr.text,
              lastName: _lastNameControlelr.text,
              email: _emailControlelr.text,
              password: _passwordControlelr.text)
          .then((value) async {
        if (value["error"] == "X") {
          _createAccountScaffoldKey.currentState.showSnackBar(SnackBar(
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
            backgroundColor: Theme.of(context).errorColor,
          ));
        } else {
          _emailControlelr.clear();
          _passwordControlelr.clear();
          _firstNameControlelr.clear();
          _lastNameControlelr.clear();
          _createAccountScaffoldKey.currentState.showSnackBar(SnackBar(
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
            backgroundColor: Theme.of(context).primaryColor,
          ));
          await Future.delayed(Duration(milliseconds: 2000));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (cntext) => LoginScreen()));
        }
      });
    }
    GiftAppBloc().dispatch(IsCreateAccountPageLoadingEvent(false));
  }

  @override
  Widget build(BuildContext context) {
    var _giftAppBloc = GiftAppBloc();
    return SafeArea(
        child: Scaffold(
      key: _createAccountScaffoldKey,
      appBar: AppBar(
        title: Text("Create Account"),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder(
          bloc: _giftAppBloc,
          builder: (context, currentState) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.add_circle,
                            color: Theme.of(context).primaryColor,
                            size: 40.0,
                          ),
                        ),
                      ),
                      Form(
                        key: _createAccountFormKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _firstNameControlelr,
                              textCapitalization: TextCapitalization.words,
                              decoration:
                                  InputDecoration(labelText: "First Name"),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return "First name required";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _lastNameControlelr,
                              textCapitalization: TextCapitalization.words,
                              decoration:
                                  InputDecoration(labelText: "Last Name"),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return "Last name required";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _emailControlelr,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(labelText: "Email"),
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return "Email required";
                                } else if (!value.contains("@") ||
                                    !value.contains(".")) {
                                  return "Email is not valid";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _passwordControlelr,
                              obscureText: true,
                              decoration:
                                  InputDecoration(labelText: "Password"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Password required";
                                } else if (value.length < 8) {
                                  return "Passowrd must contains at least 8 characters";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _confirmPasswordControlelr,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: "Confirm Password"),
                              validator: (value) {
                                if (value != _passwordControlelr.text) {
                                  return "Confirm password not match with password";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            _giftAppBloc.isCreateAccountPageLoading
                                ? Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(),
                            FlatButton.icon(
                                onPressed:
                                    _giftAppBloc.isCreateAccountPageLoading
                                        ? null
                                        : _onCreateAccount,
                                disabledColor: Colors.indigo[100],
                                icon: const Icon(Icons.add),
                                label: const Text("Create Account"),
                                color: Theme.of(context).primaryColor)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ));
  }
}
