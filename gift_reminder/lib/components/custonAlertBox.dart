import 'package:flutter/material.dart';

class CustomAlertBox {
  CustomAlertBox.showConfirmBox(
      {@required BuildContext context,
      @required Widget content,
      String title,
      @required Function onSure}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title ?? "Confirmation"),
              content: content,
              actions: [
                FlatButton.icon(
                    color: Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                    label: Text('Cancel')),
                FlatButton.icon(
                    color: Theme.of(context).primaryColor,
                    onPressed: onSure,
                    icon: Icon(Icons.check),
                    label: Text('Sure'))
              ],
            ));
  }

  CustomAlertBox.showInfoBox(
      {@required BuildContext context,
      @required Widget content,
      String title}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title ?? "Info"),
              content: content,
              actions: [
                FlatButton.icon(
                    color: Theme.of(context).secondaryHeaderColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
                    label: Text('Close')),
              ],
            ));
  }
}
