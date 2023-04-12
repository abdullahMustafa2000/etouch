import 'package:flutter/material.dart';

class HomePagesSwitcher with ChangeNotifier {
  bool _isFragmentsVisible = true;
  int _eIndex = 0;
  bool get getFragmentState => _isFragmentsVisible;
  int get getScreenIndex => _eIndex;
  void switchStacks() {
    _isFragmentsVisible = !_isFragmentsVisible;
    notifyListeners();
  }

  void navBtnsClicked() {
    _isFragmentsVisible = true;
    notifyListeners();
  }

  void eInvoiceEReceiptBtnClicked(int index) {
    switchStacks();
    _eIndex = index;
    notifyListeners();
  }
}