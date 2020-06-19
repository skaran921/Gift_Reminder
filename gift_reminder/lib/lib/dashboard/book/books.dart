import 'package:flutter/material.dart';
import 'package:gift_reminder/bloc/bloc.dart';
import 'package:gift_reminder/components/customIcon.dart';
import 'package:gift_reminder/components/customText.dart';
import 'package:lottie/lottie.dart';

class Books extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Books"),
          ),
          body: GiftAppBloc().books.length == 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Lottie.asset(
                            "assets/images/lottie/6552-search.json",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover)),
                    SizedBox(
                      height: 8.0,
                    ),
                    CustomText(text: "Sorry, Books Not Found!")
                  ],
                )
              : ListView.separated(
                  padding: EdgeInsets.all(8.0),
                  separatorBuilder: (context, index) => Divider(
                        thickness: 0.3,
                        color: Theme.of(context).textTheme.body2.color,
                      ),
                  itemCount: GiftAppBloc().books.length - 1,
                  itemBuilder: (context, index) {
                    var book = GiftAppBloc().books[index + 1];
                    print(GiftAppBloc().books);
                    return ListTile(
                      leading: CustomIcon(icon: Icons.book),
                      title: CustomText(text: "Book ${book['BOOK_NUMBER']}"),
                      subtitle: CustomText(text: "Book ID: ${book['BOOK_ID']}"),
                      trailing: CustomText(text: "${book['BOOK_STATUS']}"),
                    );
                  })),
    );
  }
}
