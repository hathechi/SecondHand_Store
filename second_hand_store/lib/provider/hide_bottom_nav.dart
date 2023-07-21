import 'package:flutter/cupertino.dart';

class HideBottomNavProvider extends ChangeNotifier {
  bool hideBottomNavigationBar = false;
  void hideBottomNav() {
    hideBottomNavigationBar = true;
    notifyListeners();
  }

  void showBottomNav() {
    hideBottomNavigationBar = false;
    notifyListeners();
  }
}
