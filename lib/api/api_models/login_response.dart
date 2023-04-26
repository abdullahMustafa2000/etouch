import 'dart:convert';

import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';

class LoginResponse {
  String token;
  DateTime expiration;
  List<String> userRules;
  int foundationId;
  int companyId;
  List<BaseAPIObject> userBranches;

  LoginResponse(
      {required this.token,
      required this.expiration,
      required this.userRules,
      required this.foundationId,
      required this.companyId,
      required this.userBranches});

  Map<String, dynamic> toJson(LoginResponse response) {
    return {
      'token': response.token,
      'expiration': response.expiration,
      'userRoles': response.userRules,
      'foundationId': response.foundationId,
      'companyId': response.companyId,
      'userBranches': response.userBranches,
    };
  }

  factory LoginResponse.fromJson(Map<String, dynamic> jsonData) {
    return LoginResponse(
        token: jsonData['token'],
        expiration: jsonData['expiration'],
        userRules: jsonData['userRules'],
        foundationId: jsonData['foundationId'],
        companyId: jsonData['companyId'],
        userBranches: jsonData['userBranches']);
  }
}
