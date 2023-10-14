import 'package:etouch/api/api_models/product_content.dart';

import '../../businessLogic/classes/e_invoice_item_selection_model.dart';

class ViewProduct extends ProductModel {
  BaseAPIObject? groupSelected, unitSelected;
  double? quantity;
  double? totalProdAmount;

  ViewProduct.empty() {
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
    totalProdAmount = 0;
  }

  ViewProduct.map(ProductModel product) {
    productId = product.productId;
    productName = product.productName;
    pieceSalePrice = product.pieceSalePrice;
    minSalePrice = product.minSalePrice;
    maxSalePrice = product.maxSalePrice;
    egsCode = product.egsCode;
    gs1Code = product.gs1Code;
    itemCodeType = product.itemCodeType;
    warehouseProductGroupsId = product.warehouseProductGroupsId;
    productCount = product.productCount;
    measurementUnitsId = product.measurementUnitsId;
    measurementUnitsName = product.measurementUnitsName;
  }

}