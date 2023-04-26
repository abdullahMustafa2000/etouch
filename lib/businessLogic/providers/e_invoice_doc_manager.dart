import 'package:flutter/material.dart';

import '../../api/api_models/product_content.dart';

class EInvoiceDocProvider with ChangeNotifier {
  double _totalPrice = 0.0;
  List<ProductModel> _prodList = [];

  List<ProductModel> getProductsList() => _prodList;
  double getTotalPrice() => _totalPrice;
  void priceUpdated(List<ProductModel> list) {
    _totalPrice = 0;
    for (var element in list) {
      _totalPrice += element.totalPrice ?? 0;
    }
    listUpdated(list);
    notifyListeners();
  }

  void listUpdated(List<ProductModel> list) {
    _prodList = list;
    notifyListeners();
  }
}
