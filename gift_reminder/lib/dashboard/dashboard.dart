import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/bloc/events.dart';
import 'package:gift_reminder/components/customIcon.dart';
import 'package:gift_reminder/components/customText.dart';
import 'package:gift_reminder/components/custonAlertBox.dart';
import 'package:gift_reminder/config/admin_token.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:gift_reminder/dashboard/transaction/editTransaction.dart';
import 'package:gift_reminder/dashboard/transaction/transactions.dart';
import 'package:gift_reminder/service/transaction.dart';
import 'package:lottie/lottie.dart';
import 'package:share/share.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key key}) : super(key: key);
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  // *deleteTransaction
  void deleteTransaction(BuildContext context,
      {transactionId, transactionIndex, adminId}) {
    CustomAlertBox.showConfirmBox(
        context: context,
        title: "Delete",
        content: BlocBuilder(
          builder: (context, currentState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Are you sure you want to delete this trasaction?"),
                GiftAppBloc().isRemoveTransactionLoading
                    ? Container(
                        padding: EdgeInsets.all(4.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Container()
              ],
            );
          },
          bloc: GiftAppBloc(),
        ),
        onSure: () async {
          GiftAppBloc().dispatch(IsRemoveTransactionLoadingEvent(true));
          await TransactionService.removeTransaction(
                  adminId: adminId, transactionId: transactionId)
              .then((value) => {
                    if (value["error"] == "X")
                      {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              Lottie.asset(
                                "assets/images/lottie/error-animation.json",
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.fill,
                              ),
                              Text(
                                "${value["msg"]}",
                              )
                            ],
                          ),
                          backgroundColor: Theme.of(context).errorColor,
                        ))
                      }
                    else
                      {
                        GiftAppBloc().dispatch(
                            RemoveTransactionDataEvent(transactionIndex)),
                        Scaffold.of(context).showSnackBar(SnackBar(
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
                        )),
                        Navigator.pop(context)
                      }
                  });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.zero,
        child: Column(
          children: <Widget>[
            Container(
              height: 280,
              padding: EdgeInsets.all(12.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFFf2f2f2), Color(0xFFfafafa)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: Container(
                height: 200,
                // margin: EdgeInsets.all(22.0),
                padding: EdgeInsets.all(22.0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Color(0xFFebebeb), blurRadius: 4.0)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 18.0),
                          child: Text(
                            "INR",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xFFffc10c),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0))),
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 18.0),
                              child: Text(
                                "Records",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xFF00caff),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0))),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.database,
                                  color: Color(0xFF00caff),
                                ),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  "${GiftAppBloc().allTransaction.length}",
                                  style: TextStyle(
                                      color: Color(0xBB00caff), fontSize: 20.0),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.rupeeSign,
                                size: 20.0,
                              ),
                              Text(
                                " ${Gift.getSum(GiftAppBloc().allTransaction)} ",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).textTheme.body2.color,
                                    fontSize: 44.0),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(right: 22.0),
                            child: Lottie.asset(
                                "assets/images/lottie/23926-freelancers-life.json",
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover),
                          ),
                        )
                      ],
                    ),
                    Text(
                      "   Available Balance",
                      style: TextStyle(color: Colors.orange),
                    ),
                    SizedBox(height: 4.0),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.orangeAccent,
                                  foregroundColor: Colors.white,
                                  radius: 20.0,
                                  child: Text(
                                    "${AdminToken.adminFirstName[0]}${AdminToken.adminLastName == null ? "" : AdminToken.adminLastName[0]}",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Flexible(
                                  child: Text(
                                    "${AdminToken.adminFirstName} ${AdminToken.adminLastName}",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .color),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.email,
                                  color: Color(0xFF00caff),
                                ),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Flexible(
                                  child: Text(
                                    "${AdminToken.adminEmail}",
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        color: Theme.of(context)
                                            .textTheme
                                            .body2
                                            .color),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: CustomText(text: "Activity"),
                ),
                Container(
                  margin: EdgeInsets.only(right: 16.0),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllTransactions()));
                    },
                    color: Theme.of(context).secondaryHeaderColor,
                    child: Text("See All"),
                  ),
                ),
              ],
            ),
            Container(
              height: 400,
              child: ListView.builder(
                  primary: false,
                  itemCount: GiftAppBloc().allTransaction.length < 10
                      ? GiftAppBloc().allTransaction.length
                      : 10,
                  itemBuilder: (context, index) {
                    var isEvenRow = index % 2 == 0;
                    return Column(
                      children: [
                        Container(
                          color: !isEvenRow ? Color(0x77ededed) : null,
                          child: ExpansionTile(
                            key: ValueKey(
                                "${GiftAppBloc().allTransaction[index]['TRANSACTION_ID']}"),
                            leading: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Gift.colorsList[
                                  Random().nextInt(Gift.colorsList.length)],
                              foregroundColor: Color(0xFFfefefe),
                              child: Text(
                                "${GiftAppBloc().allTransaction[index]['NAME'][0]}"
                                    .toUpperCase(),
                                style: TextStyle(fontSize: 28.0),
                              ),
                            ),
                            title: Text(
                              "${GiftAppBloc().allTransaction[index]['NAME']}  S/o ${GiftAppBloc().allTransaction[index]['FATHER_NAME']}",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).textTheme.body2.color,
                                  fontSize: 14.0),
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
                                    "${GiftAppBloc().allTransaction[index]['AMOUNT']}.00",
                              )
                            ]),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FloatingActionButton(
                                    mini: true,
                                    heroTag: "deleteBtn",
                                    backgroundColor: Colors.red,
                                    onPressed: () {
                                      deleteTransaction(context,
                                          transactionIndex: index,
                                          adminId: AdminToken.adminId,
                                          transactionId:
                                              "${GiftAppBloc().allTransaction[index]['TRANSACTION_ID']}");
                                    },
                                    child: Icon(Icons.delete),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  FloatingActionButton(
                                    mini: true,
                                    heroTag: "shareBtn",
                                    onPressed: () {
                                      final RenderBox box = context
                                          .findAncestorRenderObjectOfType();
                                      Share.share(
                                          '${GiftAppBloc().allTransaction[index]['NAME']} Gift Me ₹ ${GiftAppBloc().allTransaction[index]['AMOUNT']}/-',
                                          subject: 'Gift Details',
                                          sharePositionOrigin:
                                              box.localToGlobal(Offset.zero) &
                                                  box.size);
                                    },
                                    child: Icon(Icons.share),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  FloatingActionButton(
                                    mini: true,
                                    heroTag: "editBtn",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditTransaction(
                                                    index: index,
                                                    name: GiftAppBloc()
                                                            .allTransaction[
                                                        index]['NAME'],
                                                    fatherName: GiftAppBloc()
                                                            .allTransaction[
                                                        index]['FATHER_NAME'],
                                                    transactionId: GiftAppBloc()
                                                                .allTransaction[
                                                            index]
                                                        ['TRANSACTION_ID'],
                                                    amount: GiftAppBloc()
                                                            .allTransaction[
                                                        index]['AMOUNT'],
                                                    phone: GiftAppBloc()
                                                            .allTransaction[
                                                        index]['PHONE'],
                                                    address: GiftAppBloc()
                                                            .allTransaction[
                                                        index]['ADDRESS'],
                                                    bookId: GiftAppBloc()
                                                            .allTransaction[
                                                        index]['BOOK_ID'],
                                                    pageNo: GiftAppBloc()
                                                            .allTransaction[
                                                        index]['PAGE_NUMBER'],
                                                  )));
                                    },
                                    child: Icon(Icons.edit),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                ],
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.book,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                                title: CustomText(
                                  text: "Book No.",
                                ),
                                subtitle: CustomText(
                                    text:
                                        "${GiftAppBloc().allTransaction[index]['BOOK_ID']}"),
                                trailing: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(text: "Page No."),
                                    CustomText(
                                        text:
                                            "${GiftAppBloc().allTransaction[index]['PAGE_NUMBER']}")
                                  ],
                                ),
                              ),
                              ListTile(
                                leading: CustomIcon(icon: Icons.person),
                                title: CustomText(text: "Name"),
                                subtitle: CustomText(
                                    text:
                                        "${GiftAppBloc().allTransaction[index]['NAME']}"),
                              ),
                              ListTile(
                                leading: CustomIcon(icon: Icons.person_outline),
                                title: CustomText(text: "Father Name"),
                                subtitle: CustomText(
                                    text:
                                        "${GiftAppBloc().allTransaction[index]['FATHER_NAME']}"),
                              ),
                              ListTile(
                                leading: CustomIcon(icon: Icons.home),
                                title: CustomText(text: "Address"),
                                subtitle: CustomText(
                                    text:
                                        "${GiftAppBloc().allTransaction[index]['ADDRESS']}"),
                              ),
                              ListTile(
                                leading: CustomIcon(
                                    icon: FontAwesomeIcons.rupeeSign),
                                title: CustomText(text: "Amount"),
                                subtitle: CustomText(
                                    text:
                                        "₹ ${GiftAppBloc().allTransaction[index]['AMOUNT']}/-"),
                              ),
                              ListTile(
                                leading: CustomIcon(
                                    icon: FontAwesomeIcons.mobileAlt),
                                title: CustomText(text: "Phone"),
                                subtitle: CustomText(
                                    text:
                                        "${GiftAppBloc().allTransaction[index]['PHONE'].toString().length == 0 ? 'Not Applicable' : GiftAppBloc().allTransaction[index]['PHONE']}"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            )
          ],
        ));
  }
}
