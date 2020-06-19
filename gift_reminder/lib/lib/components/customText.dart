import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;

  const CustomText({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text("$text",
        style: TextStyle(
          color: Theme.of(context).textTheme.body2.color,
        ));
  }
}
