import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  int numOfDocuments = 10;

  void updateNumOfDocuments(int num) {
    numOfDocuments = num;
    notifyListeners();
  }
}