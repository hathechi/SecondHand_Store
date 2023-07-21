import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:second_hand_store/api_services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/enter_pin_screen.dart';
import '../utils/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  User? user;
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
      user = FirebaseAuth.instance.currentUser!;

      //post user to server
      await UserService.postData(user!);

      isLogged = true;
      dismiss();

      notifyListeners();
    } catch (e) {
      dismiss();
    }
  }

  Future logoutGoogle() async {
    showLoading();
    await FirebaseAuth.instance.signOut();
    isLogged = false;
    dismiss();
    notifyListeners();

    await googleSignIn.disconnect();
    //xóa user khỏi local
    deleteToLocalStorage('user');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('verificationId');

//Hoàn thành xong tác vụ thì dừng loading
    dismiss();
    isLogged = false;
    notifyListeners();
  }

  ///// PHONE /////
  ///
  String verificationId = '';
  String otp = '';

  Future<void> signInWithPhoneNumber(
      String phoneNumber, BuildContext context) async {
    showLoading();

    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await auth.signInWithCredential(credential);
        // print('Verification completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: $e');
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        //Lưu mã verificationId lại
        prefs.setString('verificationId', verificationId);
        log('save key ok');
        print('Code sent to $phoneNumber');
        dismiss();

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const EnterPin(),
        ));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Xử lý khi quá thời gian chờ tự động nhận mã xác thực
      },
    );
  }

  Future<bool> signInWithOTP() async {
    bool? checkLogin;
    showLoading();
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    log("key: ${prefs.getString('verificationId')!}");
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: prefs.getString('verificationId')!,
      smsCode: otp,
    );
    await auth.signInWithCredential(credential).then((value) {
      dismiss();
      isLogged = true;
      print('Verification completed $value');
      checkLogin = true;
      notifyListeners();
    }).catchError((error) {
      dismiss();
      print('Verification failed: $error');
      checkLogin = false;
    });
    return checkLogin!;
  }

  void setOTP(String otpValue) {
    otp = otpValue;
    notifyListeners();
  }
}
