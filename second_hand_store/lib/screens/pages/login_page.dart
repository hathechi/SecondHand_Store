import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/utils/colors.dart';
import 'package:video_player/video_player.dart';

import '../../provider/google_signin.dart';
import '../../utils/show_toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late VideoPlayerController _controller;
  final _showLoginPhone = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
      "assets/images/video.mp4",
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.play();
    _controller.setVolume(0);
    _controller.setLooping(true);
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          VideoPlayer(_controller),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Đăng nhập / Đăng ký',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 26),
                  BtnLogin(
                    color: Colors.transparent,
                    title: "Đăng nhập với Google",
                    colorTitle: Colors.black,
                    urlImage:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png',
                    onClick: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
                      if (!provider.isLoading) {
                        provider.loginGoogle();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  BtnLogin(
                    color: Colors.blueAccent,
                    title: "Đăng nhập bằng Facebook",
                    colorTitle: Colors.white,
                    urlImage:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/0/05/Facebook_Logo_%282019%29.png/900px-Facebook_Logo_%282019%29.png',
                    onClick: () {
                      showToast('Chức năng đang phát triển', Colors.red);
                    },
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _showLoginPhone,
                    builder: (context, value, child) {
                      return InkWell(
                        onTap: () =>
                            _showLoginPhone.value = !_showLoginPhone.value,
                        child: AnimatedCrossFade(
                            sizeCurve: Curves.linearToEaseOut,
                            firstChild: const SizedBox(
                              width: double.infinity,
                              height: 100,
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.chevron_down,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text('Xem thêm'),
                                ],
                              )),
                            ),
                            secondChild: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 100),
                              child: BtnLogin(
                                color: Colors.transparent,
                                title: "Dùng số điện thoại",
                                colorTitle: Colors.black,
                                urlImage:
                                    'https://e7.pngegg.com/pngimages/982/427/png-clipart-telephone-icon-telephone-call-computer-icons-iphone-symbol-telefono-electronics-rim.png',
                                onClick: () {
                                  showPhoneInputDialog(context);
                                },
                              ),
                            ),
                            crossFadeState: value
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 200)),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showPhoneInputDialog(BuildContext context) async {
  String? phoneNumber = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return const PhoneInputDialog();
    },
  );

  if (phoneNumber != null) {
    // Xử lý số điện thoại được nhập vào
    // ignore: use_build_context_synchronously
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.signInWithPhoneNumber("+84$phoneNumber", context);
  } else {
    // Người dùng đã hủy nhập số điện thoại
    print('Phone input cancelled');
  }
}

class PhoneInputDialog extends StatefulWidget {
  const PhoneInputDialog({super.key});

  @override
  _PhoneInputDialogState createState() => _PhoneInputDialogState();
}

class _PhoneInputDialogState extends State<PhoneInputDialog> {
  final TextEditingController _phoneController = TextEditingController();
  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tiếp tục với số điện thoại'),
      contentPadding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      content: Container(
        width: 400,
        height: 120,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: SizedBox(
          height: 70,
          child: TextFormField(
            keyboardType: TextInputType.phone,
            maxLength: 10,
            controller: _phoneController,
            decoration: const InputDecoration(
                prefixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('+84'),
                    )
                  ],
                ),
                // hintText: '+84',
                alignLabelWithHint: true,
                hintStyle: TextStyle(fontSize: 15),
                contentPadding: EdgeInsets.only(left: 16),
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.2),
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Lấy giá trị số điện thoại từ TextField
            phoneNumber = _phoneController.text;
            // Đóng Dialog và trả về số điện thoại
            Navigator.of(context).pop(phoneNumber);
          },
          child: const Text('Gửi OTP'),
        ),
        TextButton(
          onPressed: () {
            // Đóng Dialog mà không trả về giá trị
            Navigator.of(context).pop();
          },
          child: const Text('Đóng'),
        ),
      ],
    );
  }
}

class BtnLogin extends StatelessWidget {
  final String urlImage;
  final String title;
  final Color color;
  final Color colorTitle;
  final Function? onClick;
  const BtnLogin({
    super.key,
    required this.urlImage,
    required this.title,
    required this.color,
    this.onClick,
    required this.colorTitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onClick?.call();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Colors.blue),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(color: colorTitle),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Image.network(
                urlImage,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
