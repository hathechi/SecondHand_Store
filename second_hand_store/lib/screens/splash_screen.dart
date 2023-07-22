import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/screens/home_screen.dart';

import '../provider/google_signin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        //check xem trạng thái đăng nhập có hay không
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            //Nếu có thông tin đăng nhập thì chuyển sang màn home ngược lại thì về đăng nhập
            provider.user = FirebaseAuth
                .instance.currentUser!; //Lưu thông tin đăng nhập vào provider
            provider.isLogged = snapshot.hasData;
          }

          return const HomeScreen();
        },
      ),
    );
  }
}
