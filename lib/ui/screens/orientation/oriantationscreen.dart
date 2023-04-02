import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/orientation_screen_model.dart';
import 'package:etouch/ui/screens/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrientaionScreen extends StatefulWidget {
  @override
  State<OrientaionScreen> createState() => _OrientaionScreenState();
}

class _OrientaionScreenState extends State<OrientaionScreen> {
  PageController pageController = PageController();
  int pageIndex = 0;
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void moveToNextPage(PageController controller) {
    controller.nextPage(
        duration: const Duration(milliseconds: 800), curve: Curves.slowMiddle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          OrientationModel(
            title: AppLocalizations.of(context)!.orientationEInvoiceTitle,
            desc: AppLocalizations.of(context)!.orientationEInvoiceDesc,
            lottiePath: eInvoiceLottiePath,
            controller: pageController,

            onNextClick: () {
              setState(() {
                moveToNextPage(pageController);
              });
            },
          ),
          OrientationModel(
            title: AppLocalizations.of(context)!.orientationEReceiptTitle,
            desc: AppLocalizations.of(context)!.orientationEReceiptDesc,
            lottiePath: eReceiptLottiePath,
            controller: pageController,
            onNextClick: () {
              setState(() {
                moveToNextPage(pageController);
              });
            },
          ),
          OrientationModel(
            title: AppLocalizations.of(context)!.orientationWelcomeTitle,
            desc: AppLocalizations.of(context)!.orientationWelcomeDesc,
            lottiePath: welcomeLottiePath,
            controller: pageController,
            onNextClick: () {
              setState(() {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            },
          ),
        ],
      ),
    );
  }
}
