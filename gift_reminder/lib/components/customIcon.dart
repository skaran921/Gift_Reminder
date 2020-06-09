import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final IconData icon;

  const CustomIcon({Key key, this.icon}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }
}
