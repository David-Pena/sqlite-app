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
      toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
    );
  }
}
