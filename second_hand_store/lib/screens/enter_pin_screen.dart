import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/utils/show_toast.dart';

import '../provider/google_signin.dart';

class EnterPin extends StatefulWidget {
  const EnterPin({super.key});

  @override
  State<EnterPin> createState() => _EnterPinState();
}

class _EnterPinState extends State<EnterPin> {
  final pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Nhập OTP',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Image.asset('assets/images/forgotpass.png'),
              // const Text('Enter your PIN to comfirm to payment'),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                child: PinCodeTextField(
                  length: 6,
                  // obscuringWidget: const Icon(
                  //   FontAwesomeIcons.faceAngry,
                  //   size: 30,
                  // ),
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  textStyle: const TextStyle(fontSize: 30),
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(20),
                      fieldHeight: 60,
                      fieldWidth: 60,
                      borderWidth: 0.5,
                      activeColor: Colors.black,
                      inactiveColor: const Color.fromARGB(255, 216, 215, 215),
                      inactiveFillColor: Colors.black,
                      selectedColor: Colors.white,
                      activeFillColor: Colors.white,
                      disabledColor: Colors.red,
                      selectedFillColor: Colors.black),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.white,
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  controller: pinController,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 50),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          elevation: 8,
                          shape: (RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(130)))),
                      onPressed: () async {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);

                        final otp = pinController.text.trim();
                        log(otp);
                        provider.setOTP(otp);
                        await provider.signInWithOTP().then(
                          (value) {
                            log("Value $value");
                            if (value) {
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop();
                            } else {
                              // ignore: use_build_context_synchronously
                              showSnackbar(context, 'Code bạn nhập chưa đúng',
                                  Colors.red);
                            }
                          },
                        );
                      },
                      label: const Text(
                        'Continue',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      icon: const Icon(
                        FontAwesomeIcons.chevronRight,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
