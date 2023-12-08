import 'package:etouch/api/api_models/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/base_api_response.dart';

class UserInfoPreferences {
  static const tokenKey = "USER_TOKEN";
  static const userNameKey = "USER_NAME";
  static const userImgKey = "USER_IMG";
  static const companyIdKey = "COMPANY_ID";
  static const foundationIdKey = "FOUNDATION_ID";
  static const userBranchesKey = "BRANCHES_LIST";
  static const userRulesKey = "RULES_LIST";
  static const expirationDateKey = "EXPIRATION_DATE";
  static const loginUserNameKey = "LOGIN_USERNAME";
  static const logoutKey = "LOGGED_OUT";

  void saveUserInfo(LoginResponse res, String loginUsername) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(tokenKey, res.token!);
    preferences.setString(userNameKey, res.userName!);
    preferences.setString(userImgKey, res.imgSource ?? '');
    preferences.setInt(companyIdKey, res.companyId!);
    preferences.setInt(foundationIdKey, res.foundationId!);
    preferences.setStringList(userRulesKey, res.userRoles!);
    preferences.setString(
        expirationDateKey, res.expiration!.toIso8601String());
    preferences.setString(
        userBranchesKey, BaseAPIObject.encode(res.userBranches!));

    preferences.setString(loginUserNameKey, loginUsername);
    preferences.setBool(logoutKey, false);
  }

  Future<LoginResponse> retrieveUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var response = LoginResponse(
        userName: preferences.getString(userNameKey),
        imgSource: preferences.getString(userImgKey),
        token: preferences.getString(tokenKey) ?? '',
        expiration: DateTime.parse(preferences.getString(expirationDateKey) ??
            DateTime.now().toIso8601String()),
        userRoles: preferences.getStringList(userRulesKey) ?? [],
        foundationId: preferences.getInt(foundationIdKey) ?? -1,
        companyId: preferences.getInt(companyIdKey) ?? -1,
        userBranches: BaseAPIObject.decode(
            preferences.getString(userBranchesKey) ?? ''));
    return response;
  }

  Future<String?> getLoginUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(loginUserNameKey);
  }

  static void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(logoutKey, true);
  }

  Future<bool?> getLogoutPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(logoutKey);
  }
}
