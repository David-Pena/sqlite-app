import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Validation {
  bool isEmpty(String text) {
    bool val = true;
    if (text != "") {
      val = false;
    }
    return val;
  }

  void showToastText() {
    Fluttertoast.showToast(
      msg: 'You have to complete all the fields',
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
