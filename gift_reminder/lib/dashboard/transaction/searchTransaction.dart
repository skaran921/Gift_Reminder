import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/components/convertDate.dart';
import 'package:gift_reminder/components/customIcon.dart';
import 'package:gift_reminder/components/customText.dart';
import 'package:gift_reminder/config/gift.dart';
import 'package:lottie/lottie.dart';

class SearchTransaction extends SearchDelegate {
// *deleteTransaction

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
        primaryColor: theme.primaryColor,
        primaryIconTheme: theme.primaryIconTheme,
        primaryColorBrightness: Brightness.light,
        primaryTextTheme: theme.textTheme,
        textTheme: TextTheme(title: TextStyle(color: Color(0xFFFEFEFE))),
        inputDecorationTheme: InputDecorationTheme(
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintStyle: TextStyle(color: Colors.white),
        ));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Card(
      child: Center(
        child: Text(query),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? GiftAppBloc().allTransaction
        : GiftAppBloc().allTransaction.where((transaction) {
            return "${transaction['NAME']}"
                .toString()
                .toLowerCase()
                .startsWith(query.toLowerCase());
          }).toList();

    if (suggestionList.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
              child: Lottie.asset("assets/images/lottie/6552-search.json",
                  width: 100, height: 100, fit: BoxFit.cover)),
          SizedBox(
            height: 4.0,
          ),
          Text("Sorry, No Record Found!")
        ],
      );
    }
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          var isEvenRow = index % 2 == 0;
          return Column(
            children: [
              Container(
                color: !isEvenRow ? Color(0x77ededed) : null,
                child: ExpansionTile(
                  key: ValueKey("${suggestionList[index]['TRANSACTION_ID']}"),
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Gift
                        .colorsList[Random().nextInt(Gift.colorsList.length)],
                    foregroundColor: Color(0xFFfefefe),
                    child: Text(
                      "${suggestionList[index]['NAME'][0]}".toUpperCase(),
                      style: TextStyle(fontSize: 28.0),
                    ),
                  ),
                  title: Text(
                    "${suggestionList[index]['NAME']}",
                    style: TextStyle(
                        color: Theme.of(context).textTheme.body2.color,
                        fontSize: 12.0),
                  ),
                  subtitle: Row(children: [
                    Icon(FontAwesomeIcons.rupeeSign),
                    SizedBox(
                      width: 1.0,
                    ),
                    CustomText(
                      text: "${suggestionList[index]['AMOUNT']}.00",
                    )
                  ]),
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.book,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      title: CustomText(
                        text: "Book No.",
                      ),
                      subtitle: CustomText(
                          text: "${suggestionList[index]['BOOK_ID']}"),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(text: "Page No."),
                          CustomText(
                              text: "${suggestionList[index]['PAGE_NUMBER']}")
                        ],
                      ),
                    ),
                    ListTile(
                      leading: CustomIcon(icon: Icons.person),
                      title: CustomText(text: "Name"),
                      subtitle:
                          CustomText(text: "${suggestionList[index]['NAME']}"),
                    ),
                    ListTile(
                      leading: CustomIcon(icon: Icons.person_outline),
                      title: CustomText(text: "Father Name"),
                      subtitle: CustomText(
                          text: "${suggestionList[index]['FATHER_NAME']}"),
                    ),
                    ListTile(
                      leading: CustomIcon(icon: Icons.home),
                      title: CustomText(text: "Address"),
                      subtitle: CustomText(
                          text: "${suggestionList[index]['ADDRESS']}"),
                    ),
                    ListTile(
                      leading: CustomIcon(icon: FontAwesomeIcons.rupeeSign),
                      title: CustomText(text: "Amount"),
                      subtitle: CustomText(
                          text: "₹ ${suggestionList[index]['AMOUNT']}/-"),
                    ),
                    ListTile(
                      leading: CustomIcon(icon: FontAwesomeIcons.mobileAlt),
                      title: CustomText(text: "Phone"),
                      subtitle: CustomText(
                          text:
                              "${suggestionList[index]['PHONE'].toString().length == 0 ? 'Not Applicable' : suggestionList[index]['PHONE']}"),
                    ),
                    ListTile(
                      leading: CustomIcon(icon: FontAwesomeIcons.calendarCheck),
                      title: CustomText(text: "Create At"),
                      subtitle: CustomText(
                          text: ConvertDate.seprateDataAndTime(
                              "${suggestionList[index]['CREATE_DATE']}")),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
