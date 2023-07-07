import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  bool isLogged = false;
  bool isLoading = false;

//Sau 30s tự tắt loading
  Timer? _timer;
  int _timeAutodismiss = 10;
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

  Future loginGoogle() async {
    try {
      // Show loading..
      showLoading();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      dismiss();
      if (googleUser == null) {
        isLogged = false;
        return;
      }

      showLoading();
      final googleAuth = await googleUser.authentication;
      dismiss();
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      showLoading();

      await FirebaseAuth.instance.signInWithCredential(credential);
      isLogged = true;
      dismiss();

      notifyListeners();
    } catch (e) {
      dismiss();
    }
  }

  Future logoutGoogle() async {
    showLoading();
    await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
//Hoàn thành xong tác vụ thì dừng loading
    dismiss();
    isLogged = false;
    notifyListeners();
  }
}
