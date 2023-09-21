import 'package:flutter/material.dart';

class SidebarProvider extends ChangeNotifier {
  String _selectedMenu = 'Account';
  String get selectedMenu => _selectedMenu;

  set selectedMenu(String obj) {
    _selectedMenu = obj;
    notifyListeners();
  }
}
