import 'package:etouch/api/api_models/view_product.dart';
import 'package:etouch/main.dart';

import '../../businessLogic/classes/e_invoice_item_selection_model.dart';

class SalesOrder {
  int? branchId,
      customerId,
      treasuryId,
      warehouseId,
      orderTypeId,
      currencyId,
      orderCategoryId;
  double totalOrderAmount = 0;
  double orderAmountAfterTaxes = 0;
  double paid = 0;
  bool sendToTax = true;
  int? uuid, submissionId;
  String orderDate = getFormattedDate(DateTime.now());
  List<ViewProduct> productsList = [];
  List<BaseAPIObject> paymentMethods = [], taxesAndDiscounts = [];

  SalesOrder();

  SalesOrder.init(
      {required this.branchId,
      required this.treasuryId,
      required this.warehouseId,
      this.orderTypeId = 5,
      this.orderCategoryId = 5,
      required this.totalOrderAmount,
      required this.orderAmountAfterTaxes,
      required this.customerId,
      required this.paid,
      required this.currencyId,
      required this.productsList,
      this.sendToTax = true,
      required this.orderDate});

  bool allDataIsFine(SalesOrder order) {
    if (branchId == null ||
        customerId == null ||
        treasuryId == null ||
        warehouseId == null ||
        orderTypeId == null ||
        currencyId == null ||
        orderCategoryId == null ||
        paymentMethods.isEmpty) {
      return false;
    } else {
      if (productsList == null) return false;
      for (var prod in productsList!) {
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
      "branchId": order.branchId,
      "treasuryId": order.treasuryId,
      "warehouseId": order.warehouseId,
      "orderTypeId": order.orderTypeId,
      "orderCategoryId": order.orderCategoryId,
      "totalOrderAmount": order.totalOrderAmount,
      "totalOrderAmountAfterTaxes": order.orderAmountAfterTaxes,
      "customerId": order.customerId,
      "Paid": order.paid,
      "companyCurrencyId": order.currencyId,
      "sendToTax": order.sendToTax,
      "orderDate": order.orderDate,
      "items": order.productsList?.map((e) => productToJson(e)).toList(),
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
