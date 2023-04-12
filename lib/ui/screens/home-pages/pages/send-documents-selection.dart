import 'dart:ui';
import 'package:etouch/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../businessLogic/providers/home-screens-manager.dart';
import '../../../../businessLogic/providers/navbar-add-btn-manager.dart';
import '../../../constants.dart';
import '../../home-screen.dart';

class HomeGlassyScreen extends StatefulWidget {
  HomeGlassyScreen({Key? key}) : super(key: key);

  @override
  State<HomeGlassyScreen> createState() => _HomeGlassyScreenState();
}

class _HomeGlassyScreenState extends State<HomeGlassyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget iconWidget(
          String path, String title, bool txtAbove, BuildContext context) =>
      Column(
        children: [
          Visibility(
            visible: txtAbove,
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Container(
            padding: const EdgeInsets.all(1), // Border width
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, shape: BoxShape.circle),
            child: Image.asset(
              path,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Visibility(
            visible: !txtAbove,
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
        ],
      );
  @override
  Widget build(BuildContext context) {
    var navBtnProvider = context.watch<NavBarBtnsProvider>();
    bool btnState = navBtnProvider.getBtnState;
    var homeSwitcherProvider = context.watch<HomePagesSwitcher>();
    return Stack(
      children: [
        AnimatedOpacity(
          opacity: btnState ? 1 : 0,
          duration: Duration(milliseconds: animDuration),
          child: Container(
            height: btnState ? double.infinity : 0,
            color: Colors.white.withOpacity(.6),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: const SizedBox(
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: btnState ? 1 : 0,
          duration: Duration(milliseconds: animDuration),
          child: Center(
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navBtnProvider.addBtnClosed();
                        homeSwitcherProvider.eInvoiceEReceiptBtnClicked(1);
                      },
                      child: iconWidget(eReceiptBigIcon,
                          appTxt(context).sendEReceiptTitle, true, context),
                    ),
                    GestureDetector(
                      onTap: () {
                        navBtnProvider.addBtnClosed();
                        homeSwitcherProvider.eInvoiceEReceiptBtnClicked(0);
                      },
                      child: iconWidget(eInvoiceBigIcon,
                          appTxt(context).sendEInvoiceTitle, false, context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
