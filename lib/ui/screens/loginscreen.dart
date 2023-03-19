import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/contact_us_icon_model.dart';
import 'package:etouch/ui/elements/login_input_textbox_model.dart';
import 'package:etouch/ui/elements/primary_btn_model.dart';
import 'package:etouch/ui/screens/homescreen.dart';
import 'package:etouch/ui/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                loginTopImage,
                fit: BoxFit.fitWidth,
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
    );
  }
}

class LoginInputsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppLocalizations.of(context)!.loginTxt,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 24,
          ),
          LoginTextField(
            hint: AppLocalizations.of(context)!.loginUsernameTxt,
            isPassword: false,
            onTxtChanged: (txt) {},
          ),
          const SizedBox(
            height: 24,
          ),
          LoginTextField(
            hint: AppLocalizations.of(context)!.loginPasswordTxt,
            isPassword: true,
            onTxtChanged: (txt) {},
          ),
          const SizedBox(
            height: 24,
          ),
          PrimaryClrBtn(
              content: Center(
                child: Text(
                  AppLocalizations.of(context)!.loginTxt,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePageScreen()));
              })
        ],
      ),
    );
  }
}

class LoginContactUsWidget extends StatelessWidget {
  final ThemeManager _themeManager = ThemeManager();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
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
                    AppLocalizations.of(context)!.loginContactUsTxt,
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
