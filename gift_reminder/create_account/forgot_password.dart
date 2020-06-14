import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/components/customText.dart';
import 'package:gift_reminder/components/custonAlertBox.dart';
import 'package:gift_reminder/service/createAccount.dart';
import 'package:lottie/lottie.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _forgotPasswordKey = GlobalKey<FormState>();
  final _forgotPasswordOTPKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  final _forgotPasswordScaffoldKey = GlobalKey<ScaffoldState>();

  Future _showOtpAlert(int otp, String id) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        child: AlertDialog(
          title: const Text("OTP Sent"),
          content: BlocBuilder(
            bloc: GiftAppBloc(),
            builder: (context, state) {
              return Form(
                key: _forgotPasswordOTPKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "OTP has been sent to your email",
                      style: TextStyle(
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          color: Theme.of(context).textTheme.body2.color),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _otpController,
                      decoration:
                          InputDecoration(labelText: "Enter Six Digit OTP"),
                      maxLength: 6,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter OTP";
                        } else if (value.length != 6) {
                          return "Password is not valid";
                        }
                        return null;
                      },
                    ),
                    GiftAppBloc().isOTPLoading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Container()
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              color: Theme.of(context).secondaryHeaderColor,
              child: const Text("Close"),
              onPressed: () {
                _otpController.clear();
                GiftAppBloc().dispatch(IsOTPLoadingEvent(false));
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              color: Theme.of(context).primaryColor,
              child: const Text("Go"),
              onPressed: () async {
                GiftAppBloc().dispatch(IsOTPLoadingEvent(true));
                if (_forgotPasswordOTPKey.currentState.validate()) {
                  _forgotPasswordKey.currentState.save();
                  if (otp.toString() == _otpController.text) {
                    // print("valid otp");
                    await CreateAccountService
                            .forgotPasswordAferOtpConfirmation(
                                email: _emailController.text,
                                newPassword: _newPasswordController.text,
                                adminId: id)
                        .then((value) {
                      if (value['error'] == "X") {
                        // invalid otp
                        CustomAlertBox.showInfoBox(
                            title: "Error",
                            context: context,
                            content: CustomText(text: "${value['msg']}"));
                      } else {
                        Navigator.pop(context);
                        _confirmPasswordController.clear();
                        _newPasswordController.clear();
                        _otpController.clear();
                        _emailController.clear();
                        // invalid otp
                        CustomAlertBox.showInfoBox(
                            title: "Success",
                            context: context,
                            content: CustomText(text: "${value['msg']}"));
                      }
                    });
                  } else {
                    // invalid otp
                    CustomAlertBox.showInfoBox(
                        context: context,
                        content: CustomText(
                            text: "OTP is not vlaid, please enter valid otp."));
                  }
                }
                GiftAppBloc().dispatch(IsOTPLoadingEvent(false));
              },
            )
          ],
        ));
  }

  Future _onSubmit() async {
    FocusScope.of(context).unfocus();
    GiftAppBloc().dispatch(IsForogotPasswordPageLoadingEvent(true));
    if (_forgotPasswordKey.currentState.validate()) {
      _forgotPasswordKey.currentState.save();
      await CreateAccountService.forgotPassword(email: _emailController.text)
          .then((value) async {
        if (value['error'] == "X") {
          _forgotPasswordScaffoldKey.currentState.showSnackBar(SnackBar(
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
          _forgotPasswordScaffoldKey.currentState.showSnackBar(SnackBar(
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
          var otp = value['OTP'];
          var id = value['id'];
          await _showOtpAlert(otp, id);
        }
      });
    }
    GiftAppBloc().dispatch(IsForogotPasswordPageLoadingEvent(false));
  }

  @override
  Widget build(BuildContext context) {
    var _giftAppBloc = GiftAppBloc();
    return SafeArea(
      child: Scaffold(
        key: _forgotPasswordScaffoldKey,
        appBar: AppBar(
          title: const Text("Forogot Password"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(12.0),
          child: BlocBuilder(
            bloc: _giftAppBloc,
            builder: (context, state) {
              return Container(
                child: Card(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: Form(
                      key: _forgotPasswordKey,
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/images/forgot_password.png",
                            width: 200,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: "Registered Email"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "email required";
                              } else if (!value.contains("@") ||
                                  !value.contains(".")) {
                                return "Email is not valid";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: "New Password"),
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
                            decoration: const InputDecoration(
                                labelText: "Confirm Password"),
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
                            child: const Text("Change Password"),
                            onPressed: _onSubmit,
                            color: Theme.of(context).primaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
