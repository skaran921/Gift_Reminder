import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/bloc/state.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/service/profile.dart';
import 'package:lottie/lottie.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _editProfileFormKey = GlobalKey<FormState>();
  TextEditingController _firstNameController =
      TextEditingController(text: AdminToken.adminFirstName);
  TextEditingController _lastNameController =
      TextEditingController(text: AdminToken.adminLastName);
  TextEditingController _emailController =
      TextEditingController(text: AdminToken.adminEmail);
  TextEditingController _passwordController = TextEditingController();

  Future _onSaveProfile(BuildContext ctx) async {
    FocusScope.of(ctx).unfocus();
    if (_editProfileFormKey.currentState.validate()) {
      _editProfileFormKey.currentState.save();
      GiftAppBloc().dispatch(IsEditProfileLoadingEvent(true));

      ProfileService.updateProfile(
              adminId: AdminToken.adminId,
              fname: _firstNameController.text,
              lname: _lastNameController.text,
              email: _emailController.text,
              password: _passwordController.text)
          .then((value) {
        if (value["error"] == "X") {
          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset("assets/images/lottie/error-animation.json",
                      width: 30, height: 30, fit: BoxFit.cover),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text("${value['msg']}")
                ]),
            backgroundColor: Theme.of(ctx).errorColor,
          ));
        } else {
          AdminToken.adminFirstName = _firstNameController.text;
          AdminToken.adminLastName = _lastNameController.text;
          AdminToken.adminUpdateDate = DateTime.now().toString();
          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset("assets/images/lottie/success.json",
                      width: 30, height: 30, fit: BoxFit.cover),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text("${value['msg']}")
                ]),
            backgroundColor: Theme.of(ctx).primaryColor,
          ));
        }
      });

      GiftAppBloc().dispatch(IsEditProfileLoadingEvent(false));
    } else {
      //  show alert
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset("assets/images/lottie/error-animation.json",
                  width: 30, height: 30, fit: BoxFit.cover),
              SizedBox(
                width: 4.0,
              ),
              Text("Please fill required fields")
            ]),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _giftAppBloc = GiftAppBloc();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<GiftAppBloc, GiftAppState>(
          bloc: _giftAppBloc,
          builder: (context, currentState) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Form(
                    key: _editProfileFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                              labelText: "First Name",
                              prefix: Padding(
                                padding: EdgeInsets.only(right: 4.0),
                                child: Icon(Icons.account_circle),
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "First Name Required";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                              labelText: "Last Name",
                              prefix: Padding(
                                padding: EdgeInsets.only(right: 4.0),
                                child: Icon(Icons.person),
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Last Name Required";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                              labelText: "Email",
                              prefix: Padding(
                                padding: EdgeInsets.only(right: 4.0),
                                child: Icon(Icons.email),
                              )),
                          readOnly: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email is Required";
                            } else if (!value.contains("@")) {
                              return "Not a valid email";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              labelText: "Current Password",
                              prefix: Padding(
                                padding: EdgeInsets.only(right: 4.0),
                                child: Icon(Icons.lock),
                              )),
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Current Password Required";
                            }
                            return null;
                          },
                        ),
                        _giftAppBloc.isEditProfileLoading
                            ? Padding(
                                padding: EdgeInsets.all(4.0),
                                child: CircularProgressIndicator(),
                              )
                            : Container(),
                        FlatButton.icon(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              _onSaveProfile(context);
                            },
                            icon: const Icon(Icons.save),
                            label: const Text("Save"))
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
