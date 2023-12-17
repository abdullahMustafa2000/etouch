import 'package:etouch/businessLogic/classes/view_product.dart';

import '../../businessLogic/classes/base_api_response.dart';

class ProductModel extends BaseAPIObject {
  double? pieceSalePrice = 0;
  double? minSalePrice = 0;
  double? maxSalePrice = 0;
  String? egsCode;
  String? gs1Code;
  String? itemCodeType;
  int? warehouseProductGroupsId = 0;
  double? productCount = 0;
  int? measurementUnitsId = 0;
  String? measurementUnitsName;
  bool? isChangeable;

  ProductModel.empty() : super(id: 0, name: "") {
    pieceSalePrice = 0.00;
    minSalePrice = 0.00;
    maxSalePrice = 0.0;
    egsCode = "";
    gs1Code = "";
    itemCodeType = "";
    warehouseProductGroupsId = 0;
    productCount = 0;
    measurementUnitsId = 0;
    measurementUnitsName = "";
  }

  // ProductModel.map(ViewProduct viewProduct) {
  //   id = viewProduct.getId;
  //   name = viewProduct.getName;
  //   pieceSalePrice = viewProduct.pieceSalePrice;
  //   minSalePrice = viewProduct.minSalePrice;
  //   maxSalePrice = viewProduct.maxSalePrice;
  //   egsCode = viewProduct.egsCode;
  //   gs1Code = viewProduct.gs1Code;
  //   itemCodeType = viewProduct.itemCodeType;
  //   warehouseProductGroupsId = viewProduct.warehouseProductGroupsId;
  //   productCount = viewProduct.productCount;
  //   measurementUnitsId = viewProduct.measurementUnitsId;
  //   measurementUnitsName = viewProduct.measurementUnitsName;
  // }

  ProductModel(
      {required int id,
      required String name,
      this.pieceSalePrice,
      this.minSalePrice,
      this.maxSalePrice,
      this.egsCode,
      this.gs1Code,
      this.itemCodeType,
      this.warehouseProductGroupsId,
      this.productCount,
      this.measurementUnitsId,
      this.measurementUnitsName})
      : super(id: id, name: name);

  ProductModel.fromJson(Map<String, dynamic> json)
      : super(id: json['productId'], name: json['productName']) {
    pieceSalePrice = json['pieceSalePrice'];
    minSalePrice = json['minSalePrice'];
    maxSalePrice = json['maxSalePrice'];
    egsCode = json['egsCode'];
    gs1Code = json['gs1Code'];
    itemCodeType = json['itemCodeType'];
    warehouseProductGroupsId = json['warehouseProductGroupsId'];
    productCount = json['productCount'];
    measurementUnitsId = json['measurementUnitsId'];
    measurementUnitsName = json['measurementUnitsName'];
    isChangeable = json['isEditable'];
  }

  Map<String, dynamic> toJson(ViewProduct product) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductId'] = product.productSelected!.getId;
    data['ProductCount'] = product.quantity;
    data['MeasurementUnitId'] = product.unitSelected!.getId;
    data['WarehouseProductGroupsId'] = product.groupSelected!.getId;
    data['UnitPrice'] = product.pieceSalePrice;
    return data;
  }

  @override
  String toString() {
    return 'id:$getId, name:$getName, price:$pieceSalePrice,';
  }
}
