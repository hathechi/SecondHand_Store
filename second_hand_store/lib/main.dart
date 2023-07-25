import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:second_hand_store/provider/category_provider.dart';

import 'package:second_hand_store/provider/google_signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:second_hand_store/provider/hide_bottom_nav.dart';
import 'package:second_hand_store/provider/product_provider.dart';

import 'package:second_hand_store/screens/splash_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //config firebase in main
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  //Trong suốt thanh status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HideBottomNavProvider(),
        ),

        //Something
      ],
      builder: (context, child) {
        final botToastBuilder = BotToastInit();
        return MaterialApp(
          builder: (context, child) {
            child = botToastBuilder(context, child);
            return child;
          },
          theme: ThemeData(
            brightness: Brightness.light,
            fontFamily: GoogleFonts.manrope().fontFamily,
            // fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
          ),
          navigatorObservers: [BotToastNavigatorObserver()],
          debugShowCheckedModeBanner: false,
          home: Stack(alignment: Alignment.center, children: [
            const SplashScreen(),
            Builder(builder: (context) {
              final providerGoogle =
                  Provider.of<GoogleSignInProvider>(context, listen: true);
              final providerProduct =
                  Provider.of<ProductProvider>(context, listen: true);
              final providerCategory =
                  Provider.of<CategoryProvider>(context, listen: true);

              return providerGoogle.isLoading ||
                      providerProduct.isLoading ||
                      providerCategory.isLoading
                  ? Container(
                      color: Colors.transparent,
                      child: const CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )
                  : const SizedBox();
            })
          ]),
        );
      },
    );
  }
}
