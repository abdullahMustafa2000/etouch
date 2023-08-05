import 'dart:convert';
import 'package:etouch/api/api_models/dashboard/submitted_doc_statuses.dart';
import 'package:etouch/api/api_models/map_response.dart';
import 'package:etouch/api/api_response.dart';
import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';
import 'package:http/http.dart' as http;
import 'api_models/dashboard/dashboard_response.dart';
import 'api_models/login_response.dart';
import 'api_models/product_content.dart';
import 'api_models/sales_order.dart';

class MyApiServices {
  MyApiServices();
  static const baseUrl = 'aaabdelsabour-001-site1.atempurl.com';
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
        );
      } else {
        return APIResponse(
          data: null,
          hasError: true,
          errorMessage: '',
        );
      }
    });
  }

  Future<APIResponse<List<BaseAPIObject>>> getCustomersList(
      int branchId, String token) {
    return baseObjectRequest('accounting/Account/GetCustomersByBranchId', token,
        parameters: {'branchId': branchId.toString()});
  }

  Future<APIResponse<List<BaseAPIObject>>> getCurrenciesList(
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
        final dataSet = <BaseAPIObject>[];
        int i = 0;
        for (var jsonElement in jsonData) {
          currenciesMap[i] = jsonElement['code'];
          i++;
          final element =
              BaseAPIObject(id: i, name: jsonElement['description']);
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
          errorMessage: '',
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
      int groupId, String token) async {
    return await http.get(Uri.parse('$baseUrl'), headers: {
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
          errorMessage: '',
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

  Future<APIResponse<bool>> postEInvoiceDocument(
      SalesOrder order, String token) async {
    return await http
        .post(Uri.parse('${baseUrl}inventory/Inventory/SubmitDocument'),
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

  Future<APIResponse<DashboardResponse>> getDashboard(String token,
      {int branchId = 94, int s = 10}) async {
    return await http.get(
        Uri.http(baseUrl, 'etax/ETax/EInvoiceDashboard',
            {'branchId': branchId.toString(), 's': s.toString()}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }).then((value) {
      if (value.statusCode == 200) {
        var jsonBody = json.decode(value.body);
        final List<APIMapResponse> sales =
            DashboardResponse.basicObjList(jsonBody['sales']);
        final List<APIMapResponse> topReceivers =
            DashboardResponse.basicObjList(jsonBody['topReceivers']);
        final List<APIMapResponse> invoiceTypes =
            DashboardResponse.basicObjList(jsonBody['invoiceTypes']);
        final valid = SubmissionsStatuses.fromJson(jsonBody['valid']);
        final invalid = SubmissionsStatuses.fromJson(jsonBody['invalid']);
        final cancelled = SubmissionsStatuses.fromJson(jsonBody['cancelled']);
        final rejected = SubmissionsStatuses.fromJson(jsonBody['rejected']);
        final submitted = SubmissionsStatuses.fromJson(jsonBody['submitted']);
        final response = DashboardResponse(
            valid: valid,
            invalid: invalid,
            cancelled: cancelled,
            rejected: rejected,
            submitted: submitted,
            sales: sales,
            topReceivers: topReceivers,
            invoiceTypes: invoiceTypes);
        return APIResponse<DashboardResponse>(data: response);
      }
      return APIResponse<DashboardResponse>(data: null);
    }).catchError((_) => APIResponse<DashboardResponse>(data: null));
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
        return APIResponse<LoginResponse>(hasError: false, data: loginResponse);
      }
      return APIResponse<LoginResponse>(data: null, hasError: true);
    }).catchError(
            (_) => APIResponse<LoginResponse>(data: null, hasError: true));
  }
}
