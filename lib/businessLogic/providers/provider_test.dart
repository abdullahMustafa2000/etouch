import 'package:flutter/material.dart';

import '../../api/api_models/view_product.dart';

class TestProvider extends ChangeNotifier {
  double docTotalAmount = 0;
  int branchId = -1, warehouseId = 0;

  void updateTotalAmount(List<ViewProduct> prods) {
    double val = 0;
    for (var prod in prods) {
      val += ((prod.quantity ?? 0) * (prod.pieceSalePrice ?? 0));
    }
    docTotalAmount = val;
    notifyListeners();
  }
}