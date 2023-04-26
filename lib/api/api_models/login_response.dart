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
      'expiration': response.expiration,
      'userRoles': response.userRules,
      'foundationId': response.foundationId,
      'companyId': response.companyId,
      'userBranches': response.userBranches,
    };
  }
}
