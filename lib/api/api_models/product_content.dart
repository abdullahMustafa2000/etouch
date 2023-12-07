import 'package:etouch/businessLogic/classes/view_product.dart';

import '../../businessLogic/classes/base_api_response.dart';

class ProductModel {
  int? productId;
  String? productName;
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

  ProductModel.empty() {
    productId = 0;
    productName = "";
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

  ProductModel.map(ViewProduct viewProduct) {
    productId = viewProduct.productId;
    productName = viewProduct.productName;
    pieceSalePrice = viewProduct.pieceSalePrice;
    minSalePrice = viewProduct.minSalePrice;
    maxSalePrice = viewProduct.maxSalePrice;
    egsCode = viewProduct.egsCode;
    gs1Code = viewProduct.gs1Code;
    itemCodeType = viewProduct.itemCodeType;
    warehouseProductGroupsId = viewProduct.warehouseProductGroupsId;
    productCount = viewProduct.productCount;
    measurementUnitsId = viewProduct.measurementUnitsId;
    measurementUnitsName = viewProduct.measurementUnitsName;
  }

  ProductModel(
      {this.productId,
      this.productName,
      this.pieceSalePrice,
      this.minSalePrice,
      this.maxSalePrice,
      this.egsCode,
      this.gs1Code,
      this.itemCodeType,
      this.warehouseProductGroupsId,
      this.productCount,
      this.measurementUnitsId,
      this.measurementUnitsName});

  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
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
    data['ProductId'] = product.productId;
    data['ProductCount'] = product.quantity ?? 0.0;
    data['MeasurementUnitId'] = (product.unitSelected?.getId);
    data['WarehouseProductGroupsId'] = (product.groupSelected?.getId);
    data['UnitPrice'] = (product.pieceSalePrice);
    return data;
  }

  @override
  String toString() {
    return 'id:$productId, name:$productName, price:$pieceSalePrice,';
  }
}
