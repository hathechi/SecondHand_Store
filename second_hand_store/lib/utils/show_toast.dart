import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

void showToast(String title, Color color) {
  var cancel = BotToast.showSimpleNotification(
      title: title,
      backgroundColor: color,
      titleStyle:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
}

void showSnackbar(BuildContext context, String title, Color color) {
  ScaffoldMessenger.of(context).clearSnackBars();

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(vertical: 70, horizontal: 50),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          width: 10,
        ),
        const Icon(
          CupertinoIcons.chevron_down,
          size: 18,
          color: Colors.white,
        ),
      ],
    ),
    backgroundColor: color,
  ));
}
