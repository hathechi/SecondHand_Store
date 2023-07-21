import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

var navKey = GlobalKey<NavigatorState>();
var navKey1 = GlobalKey<FormState>();
BuildContext get getContext => navKey.currentContext!;
void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Future<void> pushScreen(BuildContext context, Widget child) async {
  hideKeyboard();
  await Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
  //  CupertinoPageRoute(builder: (context) => child,
}

Future<void> pushReplacement(BuildContext context, Widget child) async {
  hideKeyboard();
  await Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

void pop(BuildContext context) {
  Navigator.of(context).pop();
}

void pushAndRemoveUntil(BuildContext context, Widget child) {
  hideKeyboard();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) => child), // Trang mới bạn muốn thêm vào stack
    (Route<dynamic> route) => false, // Predicate để loại bỏ tất cả các trang
  );
}
// void pop() {
//   if (navKey.currentState!.canPop()) {
//     navKey.currentState!.pop();
//   }
// }


// void pushAndRemoveUntil({Widget? child}) {
//   hideKeyboard();
//   navKey.currentState!.pushAndRemoveUntil(
//       MaterialPageRoute(
//           builder: (BuildContext context) => child ?? HomeScreen()),
//       (route) => route is HomeScreen);
// }
