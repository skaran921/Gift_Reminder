import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/bloc/state.dart';
import 'package:gift_reminder/components/customText.dart';
import 'package:gift_reminder/components/custonAlertBox.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/service/transaction.dart';
import 'package:lottie/lottie.dart';

class EditTransaction extends StatefulWidget {
  final int index;
  final String transactionId;
  final String bookId;
  final String pageNo;
  final String name;
  final String fatherName;
  final String address;
  final String amount;
  final String phone;

  const EditTransaction(
      {Key key,
      @required this.transactionId,
      @required this.bookId,
      @required this.index,
      @required this.pageNo,
      @required this.name,
      @required this.fatherName,
      @required this.address,
      @required this.amount,
      @required this.phone})
      : super(key: key);
  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final _editTransactionFormKey = GlobalKey<FormState>();

  // * textControllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _pageNoController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    GiftAppBloc().dispatch(SetBookValueEvent(widget.bookId));
    _nameController.text = "${widget.name}";
    _fnameController.text = "${widget.fatherName}";
    _pageNoController.text = "${widget.pageNo}";
    _addressController.text = "${widget.address}";
    _amountController.text = "${widget.amount}";
    _phoneController.text = "${widget.phone}";
  }

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

  Future _onUpdate() async {
    FocusScope.of(context).unfocus();
    // ***if book value not selected
    if (GiftAppBloc().bookValue.isEmpty) {
      CustomAlertBox.showInfoBox(
          context: context,
          content: CustomText(text: "Please Select Book No."));
      return;
    }

    if (_editTransactionFormKey.currentState.validate()) {
      GiftAppBloc().dispatch(IsUpdateTransactionLoadingEvent(true));
      _editTransactionFormKey.currentState.save();
      //  *update transaction
      await TransactionService.updateTransaction(
              transactionId: widget.transactionId,
              name: _nameController.text,
              fname: _fnameController.text,
              amount: _amountController.text,
              address: _addressController.text,
              phone: _phoneController.text,
              pageNumber: _pageNoController.text,
              bookId: GiftAppBloc().bookValue,
              adminId: AdminToken.adminId)
          .then((value) {
        if (value["error"] == "X") {
          CustomAlertBox.showInfoBox(
              context: context,
              title: "Alert",
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset("assets/images/lottie/error-animation.json",
                      width: 70, height: 70, fit: BoxFit.contain),
                  CustomText(text: "${value['msg']}")
                ],
              ));
        } else {
          GiftAppBloc().dispatch(UpdateTransactionData(widget.index, {
            "TRANSACTION_ID": widget.transactionId,
            "NAME": _nameController.text,
            "FATHER_NAME": _fnameController.text,
            "AMOUNT": _amountController.text,
            "ADDRESS": _addressController.text,
            "PHONE": _phoneController.text,
            "PAGE_NUMBER": _pageNoController.text,
            "BOOK_ID": GiftAppBloc().bookValue,
            "ADMIN_ID": AdminToken.adminId
          }));
          Navigator.pop(context);
          CustomAlertBox.showInfoBox(
              context: context,
              title: "Alert",
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Lottie.asset("assets/images/lottie/success.json",
                      width: 70, height: 70, fit: BoxFit.contain),
                  CustomText(text: "${value['msg']}")
                ],
              ));
        }
      });
    } else {
      CustomAlertBox.showInfoBox(
          context: context,
          title: "Alert",
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Lottie.asset("assets/images/lottie/error-animation.json",
                  width: 70, height: 70, fit: BoxFit.contain),
              CustomText(text: "Please fill all required fields.")
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var _giftAppBloc = GiftAppBloc();
    return BlocBuilder<GiftAppBloc, GiftAppState>(
      bloc: _giftAppBloc,
      builder: (context, currentState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Transaction"),
          ),
          body: SingleChildScrollView(
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
                    onWillPop: _onWillPop,
                    key: _editTransactionFormKey,
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
                          value: widget.bookId,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: _pageNoController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: "Page No.",
                              prefix: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(Icons.plus_one),
                              )),
                          validator: (value) {
                            if (value.trim().length == 0) {
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
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: "updateBtn",
            onPressed: _giftAppBloc.isUpdateTransactionLoading
                ? null
                : () {
                    _onUpdate();
                  },
            child: _giftAppBloc.isUpdateTransactionLoading
                ? CircularProgressIndicator()
                : Icon(Icons.save),
          ),
        );
      },
    );
  }
}
