import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';

class LoginResponse {
  String? token;
  List<String>? userRoles;
  int? foundationId;
  int? companyId;
  List<BaseAPIObject>? userBranches;
  DateTime? expiration;

  LoginResponse(
      {String? token,
      List<String>? userRoles,
      int? foundationId,
      int? companyId,
      List<int>? userBranches,
      DateTime? expiration}) {
    if (token != null) {
      token = token;
    }
    if (userRoles != null) {
      userRoles = userRoles;
    }
    if (foundationId != null) {
      foundationId = foundationId;
    }
    if (companyId != null) {
      companyId = companyId;
    }
    if (userBranches != null) {
      userBranches = userBranches;
    }
    if (expiration != null) {
      expiration = expiration;
    }
  }

  LoginResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userRoles = json['userRoles'].cast<String>();
    foundationId = json['foundationId'];
    companyId = json['companyId'];
    if (json['userBranches'] != null) {
      userBranches = <BaseAPIObject>[];
      json['userBranches'].forEach((v) {
        userBranches!.add(BaseAPIObject(
            id: v, name: 'Main Branch'));
      });
    }
    expiration = DateTime.parse(json['expiration']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['userRoles'] = userRoles;
    data['foundationId'] = foundationId;
    data['companyId'] = companyId;
    if (userBranches != null) {
      data['userBranches'] = userBranches!.map((v) => v).toList();
    }
    data['expiration'] = expiration;
    return data;
  }
}
