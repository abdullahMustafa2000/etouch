import 'dart:convert';

import 'package:etouch/api/api_response.dart';
import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';
import 'package:http/http.dart' as http;

import 'api_models/login_response.dart';
import 'api_models/product_content.dart';
import 'api_models/sales_order.dart';

class MyApiServices {
  MyApiServices();
  static const base_url = '/api/';

  Future<APIResponse<List<BaseAPIObject>>> baseObjectRequest(
      String endpoint, String token) async {
    return await http.get(base_url + endpoint, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    }).then((data) {
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

  Future<APIResponse<List<BaseAPIObject>>> getCustomersList(
      int branchId, String token) {
    return baseObjectRequest(
        'accounting/Account/GetCustomersByBranchId?{$branchId}', token);
  }

  Future<APIResponse<List<BaseAPIObject>>> getCurrenciesList(
      int companyId, String token) {
    return baseObjectRequest(
        'etax/ETax/GetCurrenciesByCompanyId?{$companyId}', token);
  }

  Future<APIResponse<List<BaseAPIObject>>> getWarehousesList(
      int branchId, String token) {
    return baseObjectRequest(
        'inventory/Inventory/GetWarehousesByBranchId?{$branchId}', token);
  }

  Future<APIResponse<List<BaseAPIObject>>> getTreasuriesList(
      int branchId, String token) {
    return baseObjectRequest(
        'accounting/Account/GetTreasuriesByBranchId?{branchId=$branchId}',
        token);
  }

  Future<APIResponse<List<BaseAPIObject>>> getGroupsList(
      int branchId, int warehouseId, String token) {
    return baseObjectRequest(
        'inventory/Inventory/GetGroupsByWarehouseId?{$branchId}&$warehouseId',
        token);
  }

  Future<APIResponse<List<ProductModel>>> getProductsByGroupId(
      int groupId, String token) async {
    return await http.get('$base_url/', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    }).then((data) {
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

  Future<APIResponse<List<ProductModel>>> getProductsList(String token) async {
    return await http.get('$base_url/', headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    }).then((data) {
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

  Future<APIResponse<List<BaseAPIObject>>> getUnitsList(
      int branchId, String token) {
    return baseObjectRequest('', token);
  }

  Future<APIResponse<List<BaseAPIObject>>> getPaymentMethodsList(
      int companyId, String token) {
    return baseObjectRequest(
        'accounting/Account/GetPaymentMethodsByCompanyId?{$companyId}', token);
  }

  Future<APIResponse<List<BaseAPIObject>>> getTaxesList(
      int branchId, String token) {
    return baseObjectRequest('', token);
  }

  Future<APIResponse<bool>> postEInvoiceDocument(
      SalesOrder order, String token) async {
    return await http
        .post('${base_url}inventory/Inventory/SubmitDocument',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
            body: order.toJson(order))
        .then((value) {
      if (value.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(data: false);
    }).catchError((_) => APIResponse<bool>(data: false));
  }

  Future<APIResponse<LoginResponse>> postLoginInfo(
      String username, String password) async {
    return await http
        .post('${base_url}Account/Login',
            body: json.encode({'UserName': username, "Password": password}))
        .then((value) {
      if (value.statusCode >= 200) {
        var response = json.decode(value.body);
        LoginResponse loginResponse = LoginResponse(
          token: response['token'],
          expiration: response['expiration'],
          userRules: response['userRoles'],
          foundationId: response['foundationId'],
          companyId: response['companyId'],
          userBranches: response['userBranches'],
        );
        return APIResponse(data: loginResponse);
      }
      return APIResponse<LoginResponse>(data: null, hasError: true);
    }).catchError(
            (_) => APIResponse<LoginResponse>(data: null, hasError: true));
  }
}
