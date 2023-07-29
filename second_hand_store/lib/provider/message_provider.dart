import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import '../models/message.dart';

class MessageProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Message> listMessage = [];
  List listConversation = [];

  void addMessage(Message message) {
    listMessage.add(message);
    notifyListeners();
  }

  void showLoading() {
    if (!isLoading) {
      isLoading = true;
    }
    _cancelTimer();

    _timer = Timer.periodic(const Duration(seconds: 1), (callback) {
      log(callback.tick.toString());
      _timeAutodismiss--;
      if (_timeAutodismiss == 0) {
        callback.cancel();
        dismiss();
      }
    });
    notifyListeners();
  }

//Sau 30s tự tắt loading
  Timer? _timer;
  int _timeAutodismiss = 10;
  void _cancelTimer() {
    _timer?.cancel();
    _timeAutodismiss = 10;
  }

  void dismiss() {
    _cancelTimer();
    if (isLoading) {
      isLoading = false;
    }
    notifyListeners();
  }
}
