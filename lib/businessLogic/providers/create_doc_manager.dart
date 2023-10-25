import 'package:etouch/api/api_models/view_product.dart';
import 'package:flutter/material.dart';

class EInvoiceDocProvider extends ChangeNotifier {
  double docTotalAmount = 0, docTotalAfter = 0, paid = 0;
  int branchId = -1, warehouseId = 0;

  void updateTotalAmount(List<ViewProduct> prods) {
    double val = 0;
    for (var prod in prods) {
      val += ((prod.quantity ?? 0) * (prod.pieceSalePrice ?? 0));
    }
    docTotalAmount = val;
    notifyListeners();
  }

  void updatePaid(double val) {
    paid = val;
    updateTotalAfter(docTotalAmount - val);
    notifyListeners();
  }

  double updateTotalAfter(double val) {
    docTotalAfter = val;
    notifyListeners();
    return docTotalAfter;
  }

  void updateBranchId(int id) {
    branchId = id;
    notifyListeners();
  }

  void updateWarehouseId(int id) {
    warehouseId = id;
    notifyListeners();
  }

  void clearData() {
    docTotalAmount = 0; paid = 0;
    branchId = -1; warehouseId = 0;
    notifyListeners();
  }
}
