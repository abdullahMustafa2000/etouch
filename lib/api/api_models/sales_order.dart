import 'product_content.dart';

class SalesOrder {
  int branchId;
  int treasuryId;
  int warehouseId;
  int orderTypeId;
  int orderCategoryId;
  double totalOrderAmount;
  double orderAmountAfterTaxes;
  int customerId;
  double paid;
  int currencyId;
  bool sendToTax;
  int? uuid, submissionId;
  String orderDate;
  List<ProductModel> productsList;

  SalesOrder(
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
    };
  }
}
