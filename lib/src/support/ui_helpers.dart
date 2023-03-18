import 'package:flutter/material.dart';

class UIHelpers {
  static void displayCupertinoDialog(context, Widget child, { height = 200.0 }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SafeArea(top: false, child: child)
        );
      }
    );
  }
}