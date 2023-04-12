import 'package:flutter/material.dart';

class NavBarBtnsProvider with ChangeNotifier {
  bool _btnPushed = false;
  int _btnIndex = 0;
  bool get getBtnState => _btnPushed;
  int get getBtnIndex => _btnIndex;
  void changeAddBtnState() {
    _btnPushed = !_btnPushed;
    notifyListeners();
  }

  void addBtnClosed() {
    _btnPushed = false;
    notifyListeners();
  }

  void eInvoiceEReceiptBtnClicked(int index) {
    if (index == _btnIndex) return;
    _btnIndex = index;
    notifyListeners();
  }
}