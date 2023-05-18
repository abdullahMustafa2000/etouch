import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/orientation_screen_model.dart';
import 'package:etouch/ui/screens/login_screen.dart';
import 'package:flutter/material.dart';

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
        duration: const Duration(milliseconds: 800), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          OrientationModel(
            title: appTxt(context).orientationEInvoiceTitle,
            desc: appTxt(context).orientationEInvoiceDesc,
            lottiePath: eInvoiceLottiePath,
            controller: pageController,
            onNextClick: () {
              setState(() {
                moveToNextPage(pageController);
              });
            },
          ),
          OrientationModel(
            title: appTxt(context).orientationWelcomeTitle,
            desc: appTxt(context).orientationWelcomeDesc,
            lottiePath: welcomeLottiePath,
            controller: pageController,
            onNextClick: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
