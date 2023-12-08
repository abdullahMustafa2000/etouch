import 'package:etouch/api/api_models/currencies_reponse.dart';
import 'package:etouch/businessLogic/classes/view_product.dart';
import '../../businessLogic/classes/base_api_response.dart';
import 'tax_of_document_model.dart';

class SalesOrder {
  BaseAPIObject? branch, customer, treasury, warehouse;
  CurrenciesResponse? currency;
  double totalOrderAmount = 0;
  double orderAmountAfterTaxes = 0;
  double paid = 0;
  bool sendToTax = true;
  int? uuid, submissionId, orderTypeId, orderCategoryId, orderId;
  DateTime orderDate = DateTime.now().add(const Duration(hours: -2));
  List<ViewProduct> productsList = [];
  List<BaseAPIObject> paymentMethods = [BaseAPIObject(id: 0, name: '')];
  List<DocumentTaxesModel> taxesAndDiscounts = [];

  @override
  String toString() {
    String purpleData =
        'orderId: $orderId, branch: ${branch?.getName}, customer: ${customer?.getName}, treasury: ${treasury?.getName}, warehouse: ${warehouse?.getName}, currency: ${currency?.getName}';
    var productsData = StringBuffer();
    for (int i = 0; i < productsList.length; i++) {
      productsData.write('product$i: ${productsList[i].toString()},\n');
    }
    String paymentsData =
        'payment: ${paymentMethods[0].getName}, amount: $paid';
    return '$purpleData\n$productsData$paymentsData';
  }

  SalesOrder() {
    productsList.add(ViewProduct.empty());
  }

  onBranchWarehouseChange() {
    productsList.clear();
    productsList.add(ViewProduct.empty());
    paymentMethods.clear();
  }

  String invalidDataMsg() {
    if (productsList.isEmpty || productsList.first.productName == null) {
      return "لم يتم تحديد اصناف للارسال";
    }
    for (var prod in productsList) {
      String err = "${prod.productName}";
      if (prod.quantity == 0) {
        return "$err لم يتم تحديد كميه له ";
      } else if (prod.quantity! > prod.productCount!) {
        return "$err>> الكميه الطلوبه اكبر من المتاحه في المخرن ${prod.productCount}>> ";
      } else if (prod.pieceSalePrice! < prod.minSalePrice!) {
        return " سعر الوحده اقل من الحد الادني $err ";
      } else if (prod.pieceSalePrice! > prod.maxSalePrice!) {
        return " سعر الوحده اعلي من الحد الاقصي $err ";
      } else if (prod.pieceSalePrice! <= 0) {
        return " لم يتم تحديد سعر للوحدة $err ";
      }
    }
    if (paymentMethods.isEmpty) {
      return "No Payment Method Selected";
    }
    return '';
  }

  Map<String, dynamic> toJson(SalesOrder order) {
    Map<String, dynamic> request = <String, dynamic>{};
    request['OrderNumber'] = order.orderId;
    request['BranchId'] = order.branch!.getId;
    request["TreasuryId"] = order.treasury!.getId;
    request["WarehouseId"] = order.warehouse!.getId;
    request["OrderTypeId"] = (order.orderTypeId ?? 3);
    request["OrderCategoryId"] = (order.orderCategoryId ?? 5);
    request["GoodsStagingId"] = 4;
    request["OrderStatusId"] = 1;
    request["TotalOrderAmount"] = order.totalOrderAmount;
    request["TotalOrderAmountAfterTaxes"] = order.orderAmountAfterTaxes == 0
        ? order.totalOrderAmount
        : order.orderAmountAfterTaxes;
    request["CustomerId"] = order.customer!.getId;
    request["Paid"] = order.paid;
    request["CompanyCurrencyId"] = order.currency?.getId ?? 0;
    request["SendToTax"] = true;
    request["OrderDate"] = order.orderDate.toIso8601String();
    request["SalesOrderItems"] =
        order.productsList.map((e) => e.toJson(e)).toList();
    request["lstDiscountTaxes"] = [];
    request["lstPayments"] = order.paymentMethods
        .map((e) => {
              "PaymentMethodId": e.getId,
              "PaymentValue": order.paid,
              "TreasuryId": order.treasury?.getId
            })
        .toList();

    return request;
  }
}
