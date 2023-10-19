import 'package:etouch/api/api_models/view_product.dart';
import 'package:etouch/main.dart';

import '../../businessLogic/classes/e_invoice_item_selection_model.dart';
import 'tax_of_document_model.dart';

class SalesOrder {
  BaseAPIObject? branch, customer, treasury, warehouse, currency;
  double totalOrderAmount = 0;
  double orderAmountAfterTaxes = 0;
  double paid = 0;
  bool sendToTax = true;
  int? uuid, submissionId, orderTypeId, orderCategoryId;
  String orderDate = getFormattedDate(DateTime.now());
  List<ViewProduct> productsList = [];
  List<BaseAPIObject> paymentMethods = [BaseAPIObject(id: 0, name: '')];
  List<DocumentTaxesModel> taxesAndDiscounts = [];

  SalesOrder();

  bool allDataIsFine(SalesOrder order) {
    if (branch == null ||
        customer == null ||
        treasury == null ||
        warehouse == null ||
        orderTypeId == null ||
        currency == null ||
        orderCategoryId == null ||
        paymentMethods.isEmpty) {
      return false;
    } else {
      for (var prod in productsList) {
        if (prod.productId == null ||
            prod.quantity == null ||
            prod.measurementUnitsId == null ||
            prod.warehouseProductGroupsId == null ||
            prod.pieceSalePrice == null) {
          return false;
        }
      }
      return true;
    }
  }

  Map<String, dynamic> toJson(SalesOrder order) {
    return {
      "branchId": order.branch!.getId,
      "treasuryId": order.treasury!.getId,
      "warehouseId": order.warehouse!.getId,
      "orderTypeId": order.orderTypeId,
      "orderCategoryId": order.orderCategoryId,
      "totalOrderAmount": order.totalOrderAmount,
      "totalOrderAmountAfterTaxes": order.orderAmountAfterTaxes,
      "customerId": order.customer!.getId,
      "Paid": order.paid,
      "companyCurrencyId": order.currency!.getId,
      "sendToTax": order.sendToTax,
      "orderDate": order.orderDate,
      "items": order.productsList.map((e) => productToJson(e)).toList(),
    };
  }

  Map<String, dynamic> productToJson(ViewProduct mProduct) {
    return {
      "productId": mProduct.productId,
      "selectedBalanceMeasurementUnitId": mProduct.measurementUnitsId,
      "selectedWarehouseProductGroupId": mProduct.warehouseProductGroupsId,
      "requiredQuantity": mProduct.quantity,
      "price": mProduct.pieceSalePrice,
    };
  }
}
