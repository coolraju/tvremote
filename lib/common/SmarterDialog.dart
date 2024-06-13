import 'package:flutter/material.dart';

// SmarterDialog class
class SmarterDialog {
  // show dialog with title and message
  static void show(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(15),
                  child: CircularProgressIndicator(),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text("Loading"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
