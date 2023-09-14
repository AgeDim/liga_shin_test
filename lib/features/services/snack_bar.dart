import 'package:flutter/material.dart';
import 'package:liga_shin_test/features/style/style_library.dart';

class SnackBarService {
  static const errorColor = Colors.red;
  static const okColor = Color(0xffdec746);

  static Future<void> showSnackBar(
      BuildContext context, String message, bool error) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(message, style: StyleLibrary.text.black14,),
      backgroundColor: error ? errorColor : okColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}