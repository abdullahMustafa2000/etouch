import 'dart:convert';
import 'package:etouch/api/api_models/currencies_reponse.dart';
import 'package:etouch/api/api_response.dart';
import 'package:etouch/businessLogic/classes/base_api_response.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_models/dashboard_response.dart';
import 'api_models/login_response.dart';
import 'api_models/product_content.dart';
import 'api_models/sales_order.dart';
import 'api_models/submit_response.dart';

class MyApiServices {
  MyApiServices() {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('base_url');
    //getBaseUrl(databaseReference);
    databaseReference.onValue.listen((event) {
      baseUrl = event.snapshot.value as String;
    });
  }

  // void getBaseUrl(DatabaseReference ref) async {
  //   DataSnapshot snap = await ref.get();
  //   baseUrl = snap.value as String;
  // }

  static String baseUrl = 'baknelafyi-001-site1.ctempurl.com';
  static Map<int, String> currenciesMap = {};

  Future<APIResponse<List<BaseAPIObject>>> baseObjectRequest(
      String endpoint, String token,
      {Map<String, dynamic>? parameters}) async {
    return await http.get(Uri.http(baseUrl, '/api/$endpoint', parameters),
        headers: {
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
          statusCode: data.statusCode,
        );
      } else {
        return APIResponse(
          data: null,
          hasError: true,
          errorMessage: '',
          statusCode: data.statusCode,
        );
      }
    });
  }

  Future<APIResponse<List<BaseAPIObject>>> getCustomersList(
      int branchId, String token) {
    return baseObjectRequest('accounting/Account/GetCustomersByBranchId', token,
        parameters: {'branchId': branchId.toString()});
  }

  Future<APIResponse<List<CurrenciesResponse>>> getCurrenciesList(
      int companyId, String token) async {
    return await http.get(
        Uri.http(baseUrl, '/api/etax/ETax/GetCurrenciesByCompanyId',
            {'companyId': companyId.toString()}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final dataSet = <CurrenciesResponse>[];
        for (var jsonElement in jsonData) {
          final element =
              CurrenciesResponse.fromJson(jsonElement);
          dataSet.add(element);
        }
        return APIResponse<List<CurrenciesResponse>>(
          data: dataSet,
          hasError: false,
          statusCode: data.statusCode,
        );
      } else {
        return APIResponse(
          data: null,
          hasError: true,
          errorMessage: data.body,
          statusCode: data.statusCode,
        );
      }
    });
  }

  Future<APIResponse<List<BaseAPIObject>>> getWarehousesList(
      int branchId, String token) {
    return baseObjectRequest(
        'inventory/Inventory/GetWarehousesByBranchId', token,
        parameters: {'branchId': branchId.toString()});
  }

  Future<APIResponse<List<BaseAPIObject>>> getTreasuriesList(
      int branchId, String token) {
    return baseObjectRequest(
        'accounting/Account/GetTreasuriesByBranchId', token,
        parameters: {'branchId': branchId.toString()});
  }

  Future<APIResponse<List<BaseAPIObject>>> getGroupsList(
      int branchId, int warehouseId, String token) {
    return baseObjectRequest(
        'inventory/Inventory/GetGroupsByWarehouseId', token,
        parameters: {
          'branchId': branchId.toString(),
          'warehouseId': warehouseId.toString(),
        });
  }

  Future<APIResponse<List<ProductModel>>> getProductsByGroupId(
      int branchId, int groupId, String token) async {
    return await http.get(
        Uri.http(
            baseUrl, '/api/inventory/Inventory/GetProductsByProductGroupsId', {
          'branchId': branchId.toString(),
          'groupId': groupId.toString(),
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final dataSet = <ProductModel>[];
        for (var product in jsonData) {
          final element = ProductModel.fromJson(product);
          dataSet.add(element);
        }
        return APIResponse<List<ProductModel>>(
          data: dataSet,
          hasError: false,
          statusCode: data.statusCode,
        );
      } else {
        return APIResponse(
          data: null,
          hasError: true,
          errorMessage: '',
          statusCode: data.statusCode,
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
        'accounting/Account/GetPaymentMethodsByCompanyId', token,
        parameters: {'companyId': companyId.toString()});
  }

  Future<APIResponse<List<BaseAPIObject>>> getTaxesList(
      int branchId, String token) {
    return baseObjectRequest('', token);
  }

  Future<APIResponse<DashboardResponse>> getDashboard(String token,
      {int branchId = 94, int s = 10}) async {
    return await http.get(
        Uri.http(baseUrl, '/api/etax/ETax/EInvoiceDashboard',
            {'branchId': branchId.toString(), 'count': s.toString()}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }).then((value) {
      if (value.statusCode == 200) {
        var jsonBody = json.decode(value.body);
        return APIResponse<DashboardResponse>(
            hasError: false,
            data: DashboardResponse.fromJson(jsonBody),
            statusCode: value.statusCode);
      }
      return APIResponse<DashboardResponse>(
          data: null, statusCode: value.statusCode);
    }).catchError(
        (_) => APIResponse<DashboardResponse>(data: null, statusCode: -1));
  }

  Future<APIResponse<dynamic>> postDocument(
      SalesOrder order, String token) async {
    var toJ = json.encode(order.toJson(order));
    return await http.post(
      Uri.http(baseUrl, '/api/inventory/Inventory/SubmitDocument'),
      body: toJ,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    ).then((value) {
      if (value.statusCode == 200) {
        return APIResponse<SubmitDocumentResponse>(
            data: SubmitDocumentResponse(), statusCode: 200, hasError: false);
      }
      return APIResponse<bool>(
          data: false,
          statusCode: value.statusCode,
          errorMessage: value.body,
          hasError: true);
    });
  }

  Future<APIResponse<LoginResponse>> postLoginInfo(
      String username, String password) async {
    var header = {
      "Accept": "application/json",
      "content-type": "application/json"
    };
    var body = jsonEncode({"UserName": username, "Password": password});
    return await http
        .post(Uri.http(baseUrl, "/api/Account/Login"),
            body: body, headers: header)
        .then((value) {
      if (value.statusCode == 200) {
        var response = json.decode(value.body);
        LoginResponse loginResponse = LoginResponse.fromJson(response);
        return APIResponse<LoginResponse>(
            hasError: false, data: loginResponse, statusCode: value.statusCode);
      }
      return APIResponse<LoginResponse>(
          data: null, hasError: true, statusCode: value.statusCode);
    }).catchError((_) => APIResponse<LoginResponse>(
            data: null, hasError: true, statusCode: -1));
  }
}
