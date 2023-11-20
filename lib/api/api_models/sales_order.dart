import 'dart:convert';

import 'package:etouch/api/api_models/view_product.dart';
import 'package:etouch/main.dart';
import 'package:intl/intl.dart';

import '../../businessLogic/classes/e_invoice_item_selection_model.dart';
import 'tax_of_document_model.dart';

class SalesOrder {
  BaseAPIObject? branch, customer, treasury, warehouse, currency;
  double totalOrderAmount = 0;
  double orderAmountAfterTaxes = 0;
  double paid = 0;
  bool sendToTax = true;
  int? uuid, submissionId, orderTypeId, orderCategoryId, orderId;
  String orderDate = getZFormattedDate(DateTime.now());
  List<ViewProduct> productsList = [];
  List<BaseAPIObject> paymentMethods = [BaseAPIObject(id: 0, name: '')];
  List<DocumentTaxesModel> taxesAndDiscounts = [];

  @override
  String toString() {
    String purpleData = 'orderId: $orderId, branch: ${branch?.getName}, customer: ${customer?.getName}, treasury: ${treasury?.getName}, warehouse: ${warehouse?.getName}, currency: ${currency?.getName}';
    var productsData = StringBuffer();
    for (int i = 0; i < productsList.length; i++) {
      productsData.write('product$i: ${productsList[i].toString()},\n');
    }
    String paymentsData = 'payment: ${paymentMethods[0].getName}, amount: $paid';
    return '$purpleData\n$productsData$paymentsData';
  }

  SalesOrder();

  bool allDataIsFine() {
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
      "branchId": order.branch!.getId.toString(),
      "treasuryId": order.treasury!.getId.toString(),
      "warehouseId": order.warehouse!.getId.toString(),
      "orderTypeId": (order.orderTypeId ?? 3).toString(),
      "orderCategoryId": (order.orderCategoryId ?? 5).toString(),
      "totalOrderAmount": order.totalOrderAmount.toString(),
      "totalOrderAmountAfterTaxes": order.orderAmountAfterTaxes.toString(),
      "customerId": order.customer!.getId.toString(),
      "Paid": order.paid.toString(),
      "companyCurrencyId": order.currency!.getId.toString(),
      "sendToTax": order.sendToTax.toString(),
      "orderDate": DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
      "items": jsonEncode(order.productsList),
    };
  }
//order.productsList.map((e) => productToJson(e)).toList()
  Map<String, dynamic> productToJson(ViewProduct mProduct) {
    return {
      "productId": mProduct.productId.toString(),
      "selectedBalanceMeasurementUnitId": mProduct.measurementUnitsId.toString(),
      "selectedWarehouseProductGroupId": mProduct.warehouseProductGroupsId.toString(),
      "requiredQuantity": mProduct.quantity.toString(),
      "price": mProduct.pieceSalePrice.toString(),
    };
  }
}
