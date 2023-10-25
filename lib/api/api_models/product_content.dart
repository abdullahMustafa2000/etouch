import 'package:etouch/api/api_models/view_product.dart';

import '../../businessLogic/classes/e_invoice_item_selection_model.dart';

class ProductModel {
  int? productId;
  String? productName;
  double? pieceSalePrice;
  double? minSalePrice;
  double? maxSalePrice;
  String? egsCode;
  String? gs1Code;
  String? itemCodeType;
  int? warehouseProductGroupsId;
  double? productCount;
  int? measurementUnitsId;
  String? measurementUnitsName;
  bool isChangeable = true;

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['productName'] = productName;
    data['pieceSalePrice'] = pieceSalePrice;
    data['minSalePrice'] = minSalePrice;
    data['maxSalePrice'] = maxSalePrice;
    data['egsCode'] = egsCode;
    data['gs1Code'] = gs1Code;
    data['itemCodeType'] = itemCodeType;
    data['warehouseProductGroupsId'] = warehouseProductGroupsId;
    data['productCount'] = productCount;
    data['measurementUnitsId'] = measurementUnitsId;
    data['measurementUnitsName'] = measurementUnitsName;
    return data;
  }

  @override
  String toString() {
    return 'id:$productId, name:$productName, price:$pieceSalePrice,';
  }
}
