// ignore_for_file: must_be_immutable

import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dashboard_card_model.dart';
import 'package:etouch/ui/elements/orientation_screen_model.dart';
import 'package:etouch/ui/elements/side_menu_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:etouch/ui/elements/login_input_textbox_model.dart';

class FakeLanding extends StatelessWidget {
  PageController controller = PageController();

  FakeLanding({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorDark,
        body: Center(child: SideMenuModel(
          taxPayerName: 'Mahmoud',
          taxPayerImg: 'assets/images/fakeImage.pn',
          isDarkMood: false,
          onChangeMood: (bool val) {
            print('Current mood: ${val?'Dark':'Light'}');
          },
        )),
    );
  }
}
