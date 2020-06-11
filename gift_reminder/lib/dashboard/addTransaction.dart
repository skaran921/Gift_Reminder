import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/bloc/state.dart';
import 'package:gift_reminder/components/custonAlertBox.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:gift_reminder/service/transaction.dart';

class AddTransaction extends StatefulWidget {
  final GiftAppBloc _giftAppBloc;

  const AddTransaction({Key key, @required GiftAppBloc giftAppBloc})
      : this._giftAppBloc = giftAppBloc,
        super(key: key);
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _addTransactionFormKey = GlobalKey<FormState>();

  // * textControllers

  TextEditingController _nameController = TextEditingController();
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _pageNoController = TextEditingController(text: "1");
  TextEditingController _addressController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

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

  _onAddTransaction(BuildContext ctx) {
    FocusScope.of(context).unfocus();

    // ***if book value not selected
    if (GiftAppBloc().bookValue.isEmpty) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text("Please select book number"),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      return;
    }

    if (_addTransactionFormKey.currentState.validate()) {
      //  insertTransaction
      Map admin = jsonDecode(Gift.prefs.get(Gift.loginTokenPref));

      TransactionService.insertTransaction(
              name: _nameController.text,
              fname: _fnameController.text,
              amount: _amountController.text.trim(),
              pageNumber: _pageNoController.text.trim(),
              bookId: GiftAppBloc().bookValue,
              address: _addressController.text,
              phone: _phoneController.text,
              adminId: admin['adminId'])
          .then((value) {
        if (value["error"] == "X") {
          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text("${value["msg"]}"),
            backgroundColor: Theme.of(ctx).errorColor,
          ));
        } else {
          _nameController.clear();
          _fnameController.clear();
          _addressController.clear();
          _phoneController.clear();
          _amountController.clear();
          widget._giftAppBloc
              .dispatch(AddTransactionDataEvent(value["result"]));

          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text("${value["msg"]}"),
            backgroundColor: Theme.of(ctx).primaryColor,
          ));
        }
      });
    } else {
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text("Please fill required fields"),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _bloc = GiftAppBloc();
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
                    onWillPop: _onWillPop,
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
                                        .body2
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
                                        .body2
                                        .color),
                              ),
                            )
                          ],
                          onChanged: (value) {
                            print(value);
                            GiftAppBloc().dispatch(SetBookValueEvent(value));
                          },
                          value: GiftAppBloc().bookValue,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: _pageNoController,
                          keyboardType: TextInputType.numberWithOptions(
                              signed: false, decimal: false),
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
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
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
                          controller: _fnameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: "Father Name",
                            prefix: Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(FontAwesomeIcons.userAlt),
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "*Father Name Required";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _addressController,
                          textCapitalization: TextCapitalization.words,
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
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Phone",
                              prefix: Icon(FontAwesomeIcons.mobileAlt)),
                        ),
                        TextFormField(
                          controller: _amountController,
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
