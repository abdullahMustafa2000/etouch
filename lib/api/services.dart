import 'dart:convert';

import 'package:etouch/api/api_response.dart';
import 'package:etouch/businessLogic/classes/api_models/product_content.dart';
import 'package:etouch/businessLogic/classes/api_models/sales_order.dart';
import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';
import 'package:http/http.dart' as http;

class MyApiServices {
  MyApiServices();
  static const base_url = '/api/';
  static const token = '';
  static const headers = {
    'access-token': token,
  };

  static const currencies_endpoint = '';
  static const warehouses_endpoint = '';
  static const treasuries_endpoint = '';
  static const groups_endpoint = '';
  static const products_by_group_endpoint = '';
  static const units_endpoint = '';
  static const payment_methods_endpoint = '';
  static const taxes_discounts_endpoint = '';

  Future<APIResponse<List<BaseAPIObject>>> baseObjectRequest(String endpoint) {
    return http.get(base_url + endpoint, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final dataSet = <BaseAPIObject>[];
        for (var jsonElement in jsonData) {
          final element = BaseAPIObject(
              id: jsonElement['id'], name: jsonElement['description']);
          dataSet.add(element);
        }
        return APIResponse<List<BaseAPIObject>>(
          data: dataSet,
          hasError: false,
        );
      } else {
        return APIResponse(
          data: null,
          hasError: true,
          errorMessage: 'put your finger in your ass',
        );
      }
    });
  }

  Future<APIResponse<List<BaseAPIObject>>> getCustomersList(int branchId) {
    return baseObjectRequest(
        'accounting/Account/GetCustomersByBranchId?{$branchId}');
  }

  Future<APIResponse<List<BaseAPIObject>>> getCurrenciesList(int companyId) {
    return baseObjectRequest('etax/ETax/GetCurrenciesByCompanyId?{$companyId}');
  }

  Future<APIResponse<List<BaseAPIObject>>> getWarehousesList(int branchId) {
    return baseObjectRequest(
        'inventory/Inventory/GetWarehousesByBranchId?{$branchId}');
  }

  Future<APIResponse<List<BaseAPIObject>>> getTreasuriesList(int branchId) {
    return baseObjectRequest(
        'accounting/Account/GetTreasuriesByBranchId?{branchId=$branchId}');
  }

  Future<APIResponse<List<BaseAPIObject>>> getGroupsList(
      int branchId, int warehouseId) {
    return baseObjectRequest(
        'inventory/Inventory/GetGroupsByWarehouseId?{$branchId}&$warehouseId');
  }

  Future<APIResponse<List<ProductModel>>> getProductsByGroupId(int groupId) {
    return http.get('$base_url/', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final dataSet = <ProductModel>[];
        for (var product in jsonData) {
          final element = ProductModel(
              group: product['group'],
              unit: product['unit'],
              balance: product['balance'],
              productPrice: product['price'],
              isDeleted: false,
              id: product['id'],
              name: product['name'],
              isPriceEditable: product['editable']);
          dataSet.add(element);
        }
        return APIResponse<List<ProductModel>>(
          data: dataSet,
          hasError: false,
        );
      } else {
        return APIResponse(
          data: null,
          hasError: true,
          errorMessage: 'put your finger in your ass',
        );
      }
    });
  }

  Future<APIResponse<List<ProductModel>>> getProductsList() {
    return http.get('$base_url/', headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final dataSet = <ProductModel>[];
        for (var product in jsonData) {
          final element = ProductModel(
              group: product['group'],
              unit: product['unit'],
              balance: product['balance'],
              productPrice: product['price'],
              isDeleted: false,
              id: product['id'],
              name: product['name'],
              isPriceEditable: product['editable']);
          dataSet.add(element);
        }
        return APIResponse<List<ProductModel>>(
          data: dataSet,
          hasError: false,
        );
      } else {
        return APIResponse(
          data: null,
          hasError: true,
          errorMessage: 'put your finger in your ass',
        );
      }
    });
  }

  Future<APIResponse<List<BaseAPIObject>>> getUnitsList(int branchId) {
    return baseObjectRequest(units_endpoint);
  }

  Future<APIResponse<List<BaseAPIObject>>> getPaymentMethodsList(
      int companyId) {
    return baseObjectRequest(
        'accounting/Account/GetPaymentMethodsByCompanyId?{$companyId}');
  }

  Future<APIResponse<List<BaseAPIObject>>> getTaxesList(int branchId) {
    return baseObjectRequest(taxes_discounts_endpoint);
  }

  Future<APIResponse<bool>> postEInvoiceDocument(SalesOrder order) {
    return http
        .post('${base_url}inventory/Inventory/SubmitDocument',
            headers: headers, body: order.toJson(order))
        .then((value) {
      if (value.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(data: false);
    }).catchError((_) => APIResponse<bool>(data: false));
  }
}
