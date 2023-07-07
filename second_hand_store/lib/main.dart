import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/provider/google_signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:second_hand_store/screens/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //config firebase in main
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
          ),
          builder: BotToastInit(), //1. call BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()],
          debugShowCheckedModeBanner: false,
          home: Stack(alignment: Alignment.center, children: [
            const SplashScreen(),
            Builder(builder: (context) {
              final myProvider =
                  Provider.of<GoogleSignInProvider>(context, listen: true);
              return myProvider.isLoading
                  ? Container(
                      color: Colors.transparent,
                      child: const CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : const SizedBox();
            })
          ]),
        ),
      );
}
