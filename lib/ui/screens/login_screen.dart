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
              LoginInputsWidget(),
              const SizedBox(
                height: 24,
              ),
              LoginContactUsWidget(),
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

class LoginInputsWidget extends StatelessWidget {
  String? _emailTxt = 'suarv_hesham', _passwordTxt = '01042010';
  MyApiServices get service => GetIt.I<MyApiServices>();
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
          LoginTextFieldModel(
            hint: appTxt(context).loginUsernameTxt,
            isPassword: false,
            onTxtChanged: (txt) {
              _emailTxt = txt;
            },
            defVal: 'suarv_hesham',
          ),
          const SizedBox(
            height: 24,
          ),

          LoginTextFieldModel(
            hint: appTxt(context).loginPasswordTxt,
            isPassword: true,
            onTxtChanged: (txt) {
              _passwordTxt = txt;
            },
            defVal: '01042010',
          ),
          const SizedBox(
            height: 24,
          ),
          PrimaryClrBtnModel(
            color: Theme.of(context).primaryColor,
            content: Center(
              child: Text(
                appTxt(context).loginTxt,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Theme.of(context).primaryColorDark),
              ),
            ),
            onPressed: () async {
              //1. validate null input
              //2. request api
              //3. take action on api response
              Fluttertoast.showToast(msg: appTxt(context).pleaseWait);
              _tryLogin(_emailTxt, _passwordTxt, context);
            },
          )
        ],
      ),
    );
  }

  void _tryLogin(
      String? emailTxt, String? passwordTxt, BuildContext context) async {
    APIResponse<LoginResponse>? res;
    if (_emailTxt != null && _passwordTxt != null) {
      res = await _callLoginApi(_emailTxt!, _passwordTxt!);
      if (context.mounted) {
        _loginResponse(res, context);
      }
    }
  }

  Future<APIResponse<LoginResponse>> _callLoginApi(
      String emailTxt, String passwordTxt) async {
    APIResponse<LoginResponse> response =
        await service.postLoginInfo(emailTxt, passwordTxt);
    return response;
  }

  void _loginResponse(APIResponse<LoginResponse>? res, BuildContext context) {
    if (res?.statusCode == 200) {
      if (context.mounted) {
        UserInfoPreferences().saveUserInfo(res!.data!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageScreen(loginResponse: res.data!),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(msg: appTxt(context).loginRequestFailed);
    }
  }
}

class LoginContactUsWidget extends StatelessWidget {
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
