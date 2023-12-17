import 'package:etouch/businessLogic/classes/base_api_response.dart';
import 'package:etouch/businessLogic/classes/extensions.dart';
import 'package:etouch/main.dart';

class LoginResponse {
  String? token, imgSource, userName;
  List<String>? userRoles;
  int? foundationId;
  int? companyId;
  List<BaseAPIObject>? userBranches;
  DateTime? expiration;

  LoginResponse(
      {this.userName,
      this.imgSource,
      this.token,
      this.userRoles,
      this.foundationId,
      this.companyId,
      this.userBranches,
      this.expiration}) {
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
    imgSource = json['userImagePath'];
    userName = json['userName'];
    if (json['userBranches'] != null) {
      userBranches = <BaseAPIObject>[];
      json['userBranches'].forEach((v) {
        userBranches!.add(BaseAPIObject(id: v['id'], name: v['name']));
      });
      userBranches.filterDuplicates();
    }
    expiration = DateTime.parse(
        getSpacedFormattedDate(DateTime.parse(json['expiration'])));
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
