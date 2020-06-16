import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/components/convertDate.dart';
import 'package:gift_reminder/components/customIcon.dart';
import 'package:gift_reminder/components/customText.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:gift_reminder/service/transaction.dart';
import 'package:lottie/lottie.dart';

class CustomSearch extends StatefulWidget {
  @override
  _CustomSearchState createState() => _CustomSearchState();
}

class _CustomSearchState extends State<CustomSearch> {
  final _searchFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();

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

  Future _onSearch(BuildContext ctx) async {
    FocusScope.of(context).unfocus();
    GiftAppBloc().dispatch(IsSearchPageLoadingEvent(true));
    if (_searchFormKey.currentState.validate()) {
      _searchFormKey.currentState.save();
      await TransactionService.searchTransaction(
              searchValue: _searchController.text,
              searchBy: GiftAppBloc().searchByValue,
              adminId: AdminToken.adminId)
          .then((value) {
        print(value);
        if (value['error'] == "X") {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("${value['msg']}"),
            backgroundColor: Theme.of(context).errorColor,
          ));
        } else {
          GiftAppBloc().dispatch(SetSearchPageData(value['results']));
          if (value['length'] == 0) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("Sorry, No Record Found"),
              backgroundColor: Theme.of(context).errorColor,
            ));
          }
        }
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Search Value are Required"),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
    GiftAppBloc().dispatch(IsSearchPageLoadingEvent(false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Custom Search"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: <Widget>[
              Card(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Lottie.asset(
                            "assets/images/lottie/21333-writer.json",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover),
                      ),
                      Form(
                        onWillPop: _onWillPop,
                        key: _searchFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text("Search By"),
                            DropdownButton(
                              focusColor: Theme.of(context).primaryColor,
                              isExpanded: true,
                              value: GiftAppBloc().searchByValue,
                              items: [
                                DropdownMenuItem(
                                  value: "NAME",
                                  child: Text(
                                    "Name",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .color),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "FATHER_NAME",
                                  child: Text(
                                    "Father Name",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .color),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "PHONE",
                                  child: Text(
                                    "Phone Number",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .color),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "PAGE_NUMBER",
                                  child: Text(
                                    "Page Number",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .color),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "ADDRESS",
                                  child: Text(
                                    "Address",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .color),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: "AMOUNT",
                                  child: Text(
                                    "Amount",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .color),
                                  ),
                                )
                              ],
                              onChanged: (value) {
                                GiftAppBloc().dispatch(SetSearchByValue(value));
                              },
                            ),
                            TextFormField(
                              controller: _searchController,
                              decoration:
                                  InputDecoration(labelText: "Search Value"),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Search Value Required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            GiftAppBloc().isSearchPageLoading
                                ? Padding(
                                    padding: EdgeInsets.all(6.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Container(),
                            Center(
                                child: FlatButton.icon(
                              disabledColor: Colors.indigo[100],
                              color: Theme.of(context).primaryColor,
                              onPressed: GiftAppBloc().isSearchPageLoading
                                  ? null
                                  : () {
                                      _onSearch(context);
                                    },
                              icon: Icon(Icons.search),
                              label: Text("Search"),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GiftAppBloc().searchByValue.length == 0
                  ? Container()
                  : Container(
                      height: MediaQuery.of(context).size.height / 2.1,
                      child: ListView.builder(
                          primary: false,
                          // physics: ScrollPhysics(),
                          addAutomaticKeepAlives: true,
                          itemCount: GiftAppBloc().searchData?.length ?? 0,
                          itemBuilder: (context, index) {
                            var isEvenRow = index % 2 == 0;
                            return Column(
                              key: ValueKey(
                                  "${GiftAppBloc().searchData[index]['TRANSACTION_ID']}_CUSTOM_SEARCH_COLUMN"),
                              children: [
                                Container(
                                  color: !isEvenRow ? Color(0x77ededed) : null,
                                  child: ExpansionTile(
                                    key: ValueKey(
                                        "${GiftAppBloc().searchData[index]['TRANSACTION_ID']}_CUSTOM_SEARCH_EXPANSION_TILE"),
                                    leading: CircleAvatar(
                                      key: ValueKey(
                                          "${GiftAppBloc().searchData[index]['TRANSACTION_ID']}_CUSTOM_SEARCH_CIRCLE_AVATAR"),
                                      radius: 25.0,
                                      backgroundColor: Gift.colorsList[Random()
                                          .nextInt(Gift.colorsList.length)],
                                      foregroundColor: Color(0xFFfefefe),
                                      child: Text(
                                        "${GiftAppBloc().searchData[index]['NAME'][0]}"
                                            .toUpperCase(),
                                        style: TextStyle(fontSize: 28.0),
                                      ),
                                    ),
                                    title: Text(
                                      "${GiftAppBloc().searchData[index]['NAME']}",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .body2
                                              .color,
                                          fontSize: 12.0),
                                    ),
                                    subtitle: Row(children: [
                                      Icon(
                                        FontAwesomeIcons.rupeeSign,
                                        size: 12.0,
                                      ),
                                      SizedBox(
                                        width: 1.0,
                                      ),
                                      CustomText(
                                        text:
                                            "${GiftAppBloc().searchData[index]['AMOUNT']}.00",
                                      )
                                    ]),
                                    children: [
                                      ListTile(
                                        leading: Icon(
                                          Icons.book,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                        title: CustomText(
                                          text: "Book No.",
                                        ),
                                        subtitle: CustomText(
                                            text:
                                                "${GiftAppBloc().searchData[index]['BOOK_ID']}"),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(text: "Page No."),
                                            CustomText(
                                                text:
                                                    "${GiftAppBloc().searchData[index]['PAGE_NUMBER']}")
                                          ],
                                        ),
                                      ),
                                      ListTile(
                                        leading: CustomIcon(icon: Icons.person),
                                        title: CustomText(text: "Name"),
                                        subtitle: CustomText(
                                            text:
                                                "${GiftAppBloc().searchData[index]['NAME']}"),
                                      ),
                                      ListTile(
                                        leading: CustomIcon(
                                            icon: Icons.person_outline),
                                        title: CustomText(text: "Father Name"),
                                        subtitle: CustomText(
                                            text:
                                                "${GiftAppBloc().searchData[index]['FATHER_NAME']}"),
                                      ),
                                      ListTile(
                                        leading: CustomIcon(icon: Icons.home),
                                        title: CustomText(text: "Address"),
                                        subtitle: CustomText(
                                            text:
                                                "${GiftAppBloc().searchData[index]['ADDRESS']}"),
                                      ),
                                      ListTile(
                                        leading: CustomIcon(
                                            icon: FontAwesomeIcons.rupeeSign),
                                        title: CustomText(text: "Amount"),
                                        subtitle: CustomText(
                                            text:
                                                "₹ ${GiftAppBloc().searchData[index]['AMOUNT']}/-"),
                                      ),
                                      ListTile(
                                        leading: CustomIcon(
                                            icon: FontAwesomeIcons.mobileAlt),
                                        title: CustomText(text: "Phone"),
                                        subtitle: CustomText(
                                            text:
                                                "${GiftAppBloc().searchData[index]['PHONE'].toString().length == 0 ? 'Not Applicable' : GiftAppBloc().searchData[index]['PHONE']}"),
                                      ),
                                      ListTile(
                                        leading: CustomIcon(
                                            icon:
                                                FontAwesomeIcons.calendarCheck),
                                        title: CustomText(text: "Create At"),
                                        subtitle: CustomText(
                                            text: ConvertDate.seprateDataAndTime(
                                                "${GiftAppBloc().searchData[index]['CREATE_DATE']}")),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
