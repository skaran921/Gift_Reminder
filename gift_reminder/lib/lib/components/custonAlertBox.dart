import 'package:flutter/material.dart';

class CustomAlertBox {
  CustomAlertBox.showConfirmBox(
      {@required BuildContext context,
      @required Widget content,
      bool isLoading = false,
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
                      Navigator.pop(context, false);
                    },
                    icon: Icon(Icons.close),
                    label: const Text('Cancel')),
                FlatButton.icon(
                    disabledColor: Colors.indigo[200],
                    color: Theme.of(context).primaryColor,
                    onPressed: isLoading ? null : onSure,
                    icon: Icon(Icons.check),
                    label: const Text('Sure'))
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
                    label: const Text('Close')),
              ],
            ));
  }
}
