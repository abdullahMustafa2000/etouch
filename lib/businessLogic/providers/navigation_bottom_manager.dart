import 'package:flutter/material.dart';

class BottomNavigationProvider with ChangeNotifier {
  int indexOfPage = 0;

  void updatePageIndex(int newIndex) {
    indexOfPage = newIndex;
    notifyListeners();
  }
}