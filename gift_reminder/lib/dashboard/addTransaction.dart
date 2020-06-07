import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/state.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  var _bloc = GiftAppBloc();
  final _addTransactionFormKey = GlobalKey<FormState>();

  _onAddTransaction(BuildContext ctx) {
    FocusScope.of(context).unfocus();
    if (_addTransactionFormKey.currentState.validate()) {
    } else {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text("Please fill required fields"),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Trasaction"),
      ),
      body: BlocBuilder<GiftAppBloc, GiftAppState>(
        bloc: _bloc,
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/receipt.png",
                      width: 200,
                    ),
                  ),
                  Form(
                    key: _addTransactionFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton(
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                              value: "",
                              child: Text(
                                "Select Book",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color),
                              ),
                            ),
                            DropdownMenuItem(
                              value: "1",
                              child: Text(
                                "Book1",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color),
                              ),
                            )
                          ],
                          onChanged: (value) {},
                          value: "1",
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Page No.",
                              prefix: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.plus_one),
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "*Page No. Require";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            prefix: Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(FontAwesomeIcons.userAlt),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "*Full Name Required";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: "Address",
                              prefix: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(FontAwesomeIcons.addressCard),
                              )),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "*Address Required";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                              labelText: "Phone",
                              prefix: Icon(FontAwesomeIcons.mobileAlt)),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Amount",
                              prefix: Icon(FontAwesomeIcons.rupeeSign)),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "*Amount Required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Center(
                          child: FlatButton.icon(
                            color: Theme.of(context).primaryColor,
                            icon: Icon(Icons.add),
                            label: Text("Add Transaction"),
                            onPressed: () {
                              _onAddTransaction(context);
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
