import 'package:etouch/api/api_response.dart';
import 'package:etouch/businessLogic/shared_preferences/user_info_saver.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/login_contacts_model.dart';
import 'package:etouch/ui/elements/login_txt_input_model.dart';
import 'package:etouch/ui/elements/primary_btn_model.dart';
import 'package:etouch/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
  String? _emailTxt, _passwordTxt;
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
                if (_emailTxt != null && _passwordTxt != null) {
                  APIResponse<LoginResponse> res =
                      await _loginSucceed(_emailTxt!, _passwordTxt!);
                  if (res.data != null && !res.hasError) {
                    if (context.mounted) {
                      UserInfoPreferences().saveUserInfo(res.data!);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HomePageScreen(loginResponse: res.data!),
                        ),
                      );
                    }
                  }
                } else {}
              })
        ],
      ),
    );
  }

  Future<APIResponse<LoginResponse>> _loginSucceed(
      String emailTxt, String passwordTxt) async {
    APIResponse<LoginResponse> response =
        await service.postLoginInfo(emailTxt, passwordTxt);
    return response;
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
                onIconClicked: () {},
              ),
              ContactUsIconModel(
                icon: whatsappIcon,
                onIconClicked: () {},
              ),
              ContactUsIconModel(
                icon: gmailIcon,
                onIconClicked: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
