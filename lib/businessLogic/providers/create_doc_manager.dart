import 'package:etouch/businessLogic/classes/view_product.dart';
import 'package:flutter/material.dart';

class EInvoiceDocProvider extends ChangeNotifier {
  double totalProductsAmount = 0, docTotalAfterTaxes = 0, paid = 0;
  int branchId = 0, warehouseId = 0;

  //total after, total before
  /*
  total before:
  - calculated by (products prices * products counts)
  - changes when product updates (price or count) & when delete an item

  total after:
  - calculated by (total before + discountsAndTaxes)
  - changes when total before & discountsAndTaxes updates

  paid:
  - calculated by (total after - valEntered)
  - changes when total after & paid changes
   */

  void updateTotalAmount(List<ViewProduct> prods) {
    double val = 0;
    for (var prod in prods) {
      val += ((prod.quantity ?? 0) * (prod.pieceSalePrice ?? 0));
    }
    totalProductsAmount = val;
    notifyListeners();
  }

  void updatePaid(double val) {
    paid = val;
    updateTotalAfter(totalProductsAmount - val);
    notifyListeners();
  }

  double updateTotalAfter(double val) {
    docTotalAfterTaxes = val;
    //notifyListeners();
    return docTotalAfterTaxes;
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
    totalProductsAmount = paid = 0;
    notifyListeners();
  }
}
