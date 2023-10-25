import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Popups {
  static void flutterToast(String message, var type) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: (type == ToastType.error
            ? Colors.red
            : (type == ToastType.info ? Colors.amber : Colors.green)));
  }
}

enum ToastType { error, info, success }
