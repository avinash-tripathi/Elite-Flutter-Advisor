import 'package:flutter/material.dart';

class ScreenProvider extends ChangeNotifier {
  // ignore: prefer_final_fields
  PageController pageController = PageController(initialPage: 0);
  // PageController get pageController => _pageController;
  int _currentScreen = 0;
  int get currentScreen => _currentScreen;

  set currentScreen(int index) {
    _currentScreen = index;
    notifyListeners();
  }

  /*  set pageController(PageController obj) {
    _pageController = obj;
   // notifyListeners();
  } */
}
