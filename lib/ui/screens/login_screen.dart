import 'dart:io';
import 'package:etouch/api/api_response.dart';
import 'package:etouch/businessLogic/shared_preferences/user_info_saver.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/login_contacts_model.dart';
import 'package:etouch/ui/elements/login_txt_input_model.dart';
import 'package:etouch/ui/elements/primary_btn_model.dart';
import 'package:etouch/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/api_models/login_response.dart';
import '../../api/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: Image.asset(
                  loginTopImage,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const LoginInputsWidget(),
              const SizedBox(
                height: 24,
              ),
              const LoginContactUsWidget(),
              const SizedBox(
                height: 24,
              ),
            ],
          )
        ],
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
    );
  }
}

class LoginInputsWidget extends StatefulWidget {
  const LoginInputsWidget({Key? key}) : super(key: key);

  @override
  State<LoginInputsWidget> createState() => _LoginInputsWidgetState();
}

class _LoginInputsWidgetState extends State<LoginInputsWidget> {
  String? _emailTxt, _passwordTxt;
  bool _btnClicked = false;

  late Future<String?> _loginUsernameFut;

  Future<String?> _getLoginUsernameFromPref() async {
    return UserInfoPreferences().getLoginUserName();
  }

  MyApiServices get service => GetIt.I<MyApiServices>();

  @override
  void initState() {
    _loginUsernameFut = _getLoginUsernameFromPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            appTxt(context).loginTxt,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 24,
          ),
          FutureBuilder<String?>(
              future: _loginUsernameFut,
              builder: (context, snap) {
                _emailTxt = snap.data;
                return LoginTextFieldModel(
                  hint: appTxt(context).loginUsernameTxt,
                  isPassword: false,
                  onTxtChanged: (txt) {
                    _emailTxt = txt;
                  },
                  defVal: snap.data,
                );
              }),
          const SizedBox(
            height: 24,
          ),
          LoginTextFieldModel(
            hint: appTxt(context).loginPasswordTxt,
            isPassword: true,
            onTxtChanged: (txt) {
              _passwordTxt = txt;
            },
          ),
          const SizedBox(
            height: 24,
          ),
          PrimaryClrBtnModel(
            color: Theme.of(context).primaryColor,
            content: !_btnClicked
                ? Center(
                    child: Text(
                      appTxt(context).loginTxt,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Theme.of(context).primaryColorDark),
                    ),
                  )
                : const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                ),
            onPressed: () async {
              //1. validate null input
              //2. request api
              //3. take action on api response
              if (!_btnClicked) {
                if (_emailTxt != null &&
                    _emailTxt!.isNotEmpty &&
                    _passwordTxt != null &&
                    _passwordTxt!.isNotEmpty) {
                  setState(() {
                    _btnClicked = true;
                  });
                  _tryLogin(_emailTxt!, _passwordTxt!, context);
                } else {
                  Fluttertoast.showToast(
                      msg: appTxt(context).emptyTextFieldErr);
                }
              }
            },
          )
        ],
      ),
    );
  }

  void _tryLogin(
      String emailTxt, String passwordTxt, BuildContext context) async {
    APIResponse<LoginResponse>? res;
    res = await _callLoginApi(emailTxt, passwordTxt);
    if (context.mounted) {
      _loginResponse(res, context, emailTxt);
    }
  }

  Future<APIResponse<LoginResponse>> _callLoginApi(
      String emailTxt, String passwordTxt) async {
    APIResponse<LoginResponse> response =
        await service.postLoginInfo(emailTxt, passwordTxt);
    return response;
  }

  void _loginResponse(
      APIResponse<LoginResponse>? res, BuildContext context, String userName) {
    if (res?.statusCode == 200) {
      if (context.mounted) {
        if (res!.data!.userBranches != null ||
            res.data!.userBranches!.isEmpty) {
          UserInfoPreferences().saveUserInfo(res.data!, userName);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageScreen(loginResponse: res.data!),
            ),
          );
        } else {
          logoutUser(context);
          Fluttertoast.showToast(msg: appTxt(context).notAllowedUser);
        }
      }
    } else {
      setState(() {
        _btnClicked = false;
      });
      Fluttertoast.showToast(msg: appTxt(context).loginRequestFailed);
    }
  }
}

class LoginContactUsWidget extends StatelessWidget {
  const LoginContactUsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Theme.of(context).primaryColorDark,
                    Theme.of(context).primaryColor,
                  ])),
                )),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Text(
                      appTxt(context).loginContactUsTxt,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Theme.of(context).primaryColor),
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColorDark,
                  ])),
                )),
              ],
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ContactUsIconModel(
                icon: logo,
                onIconClicked: () async {
                  await goToWebPage();
                },
              ),
              ContactUsIconModel(
                icon: whatsappIcon,
                onIconClicked: () {
                  openWhatsapp();
                },
              ),
              ContactUsIconModel(
                icon: gmailIcon,
                onIconClicked: () {
                  openGmail();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> goToWebPage() async {
    final Uri url = Uri.parse('http://toucherp.ris-me.com/Account/Login');
    if (!await launchUrl(url)) {
      Fluttertoast.showToast(msg: 'Could not launch Touch ERP Sing up');
    }
  }

  void openGmail() async {
    String email = Uri.encodeComponent("ryada2006.2020@gmail.com");
    String subject = Uri.encodeComponent("Hello, I need help");
    String body = Uri.encodeComponent("My problem is...");
    Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
    if (!await launchUrl(mail)) {
      Fluttertoast.showToast(msg: 'Cannot open gmail, Unknown problem');
    }
  }
}

void openWhatsapp() async {
  var whatsapp = "+201154913903";
  var whatsappUrlAndroid = "whatsapp://send?phone=$whatsapp&text=hello";
  var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
  if (Platform.isIOS) {
// for iOS phone only
    if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
      await launchUrl(
        Uri.parse(whatsappURLIos),
      );
    } else {
      Fluttertoast.showToast(msg: 'Install WhatsApp first');
    }
  } else {
// android , web
    if (await canLaunchUrl(Uri.parse(whatsappUrlAndroid))) {
      await launchUrl(Uri.parse(whatsappUrlAndroid));
    } else {
      Fluttertoast.showToast(msg: 'Install WhatsApp first');
    }
  }
}
