import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SnackBarMessage {
  void showSuccessSnackBar({message, context}) {
    Flushbar(
      message: message,
      icon: Icon(
        Icons.done,
        size: 28.0,
        color: Colors.green[300],
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.green[300],
    )..show(context);
  }

  void showErrorSnackBar({message, context}) {
    Flushbar(
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.redAccent,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.redAccent,
    )..show(context);
  }
}
