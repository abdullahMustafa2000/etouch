import 'package:etouch/api/api_models/sales_order.dart';
import 'package:etouch/api/api_models/view_product.dart';
import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';
import 'package:flutter/material.dart';

class EInvoiceDocProvider extends ChangeNotifier {
  SalesOrder salesOrder = SalesOrder();
  List<BaseAPIObject>? companyCurrencies = [];
  List<BaseAPIObject>? companyPaymentMethods = [];

  void initCurrenciesList(List<BaseAPIObject> currencies) {
    companyCurrencies = currencies;
    notifyListeners();
  }
  void initProList(List<ViewProduct> products) {
    salesOrder.productsList = products;
    notifyListeners();
  }

  void updateBranchId(int? newId) {
    salesOrder.branchId = newId;
    notifyListeners();
  }

  void updateWarehouseId(int? newId) {
    salesOrder.warehouseId = newId;
    notifyListeners();
  }

  void updateDocTotalPrice(double newTotal) {
    salesOrder.totalOrderAmount = newTotal;
    notifyListeners();
  }

  void updatePaidAmount(double newVal) {
    salesOrder.paid = newVal;
    notifyListeners();
  }

  void calcDocTotalPrice() {
    salesOrder.totalOrderAmount = 0;
    for (var prod in salesOrder.productsList ?? []) {
      salesOrder.totalOrderAmount +=
          ((prod.pieceSalePrice ?? 0) * (prod.quantity ?? 0));
    }
    notifyListeners();
  }
}
