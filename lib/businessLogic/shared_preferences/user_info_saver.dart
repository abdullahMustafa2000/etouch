import 'package:etouch/api/api_models/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/base_api_response.dart';

class UserInfoPreferences {
  static const tokenPef = "USER_TOKEN";
  static const userName = "USER_NAME";
  static const userImg = "USER_IMG";
  static const COMPANY_ID_PREF = "COMPANY_ID";
  static const FOUNDATION_ID_PREF = "FOUNDATION_ID";
  static const USER_BRANCHES = "BRANCHES_LIST";
  static const USER_RULES = "RULES_LIST";
  static const EXPIRATION_DATE = "EXPIRATION_DATE";
  static const LOGGED_IN = "USER_LOGGED_IN";

  void saveUserInfo(LoginResponse res) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(tokenPef, res.token!);
    preferences.setString(userName, res.userName!);
    preferences.setString(userImg, res.imgSource ?? '');
    preferences.setInt(COMPANY_ID_PREF, res.companyId!);
    preferences.setInt(FOUNDATION_ID_PREF, res.foundationId!);
    preferences.setStringList(USER_RULES, res.userRoles!);
    preferences.setString(EXPIRATION_DATE, res.expiration!.toIso8601String());
    preferences.setString(
        USER_BRANCHES, BaseAPIObject.encode(res.userBranches!));
  }

  Future<LoginResponse> retrieveUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = LoginResponse(
        token: preferences.getString(tokenPef) ?? '',
        expiration: DateTime.parse(preferences.getString(EXPIRATION_DATE) ??
            DateTime.now().toIso8601String()),
        userRoles: preferences.getStringList(USER_RULES) ?? [],
        foundationId: preferences.getInt(FOUNDATION_ID_PREF) ?? -1,
        companyId: preferences.getInt(COMPANY_ID_PREF) ?? -1,
        userBranches:
            BaseAPIObject.decode(preferences.getString(USER_BRANCHES) ?? ''));
    return response;
  }
}
