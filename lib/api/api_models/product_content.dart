import '../../businessLogic/classes/e_invoice_item_selection_model.dart';

class ProductModel {
  int? productId;
  String? productName;
  int? warehouseProductGroupsId;
  int? productCount;
  int? measurementUnitsId;
  double? price;

  BaseAPIObject? group, unit;

  ProductModel(
      {this.productId,
        this.productName,
        this.warehouseProductGroupsId,
        this.productCount,
        this.measurementUnitsId,
        this.price});

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    warehouseProductGroupsId = json['warehouseProductGroupsId'];
    productCount = double.parse(json['productCount'].toString()).toInt();
    measurementUnitsId = json['measurementUnitsId'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['warehouseProductGroupsId'] = warehouseProductGroupsId;
    data['productCount'] = productCount;
    data['measurementUnitsId'] = measurementUnitsId;
    return data;
  }
}
