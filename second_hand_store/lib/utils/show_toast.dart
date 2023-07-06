import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

void showToast(String title, Color color) {
  var cancel = BotToast.showSimpleNotification(
      title: title,
      backgroundColor: color,
      titleStyle:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
}
