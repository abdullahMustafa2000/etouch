// ignore_for_file: must_be_immutable
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dashboard_card_model.dart';
import 'package:etouch/ui/elements/orientation_screen_model.dart';
import 'package:etouch/ui/elements/side_menu_model.dart';
import 'package:etouch/ui/screens/einvoice/create_document.dart';
import 'package:etouch/ui/screens/einvoice/e_invoice_dashboard.dart';
import 'package:etouch/ui/screens/homescreen.dart';
import 'package:etouch/ui/screens/loginscreen.dart';
import 'package:etouch/ui/screens/orientation/oriantationscreen.dart';
import 'package:etouch/ui/screens/splashscreen.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:etouch/ui/elements/login_input_textbox_model.dart';

class FakeLanding extends StatefulWidget {
  @override
  State<FakeLanding> createState() => _FakeLandingState();
}

class _FakeLandingState extends State<FakeLanding>
    with TickerProviderStateMixin {
  PageController controller = PageController();
  late AnimationController animController;
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _playAnim();
  }

  Future<void> _playAnim() async {
    try {
      await animController.forward().orCancel;
    } on TickerCanceled {
      // something happened
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CreateDocumentScreen()),
    );
  }
}
