import 'dart:ffi';

import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/primary_btn_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OrientationModel extends StatelessWidget {
  OrientationModel(
      {Key? key,
      required this.title,
      required this.desc,
      required this.lottiePath,
      required this.controller})
      : super(key: key);
  String lottiePath;
  String title, desc;
  PageController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Lottie.asset(lottiePath)),
          Expanded(
              child: DiscussionWidget(
            title: title,
            desc: desc,
            pageController: controller,
          )),
        ],
      ),
    );
  }
}

class DiscussionWidget extends StatelessWidget {
  DiscussionWidget(
      {Key? key,
      required this.title,
      required this.desc,
      required this.pageController})
      : super(key: key);
  String title;
  String desc;
  PageController pageController;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: !isRTL(context)
            ? const BorderRadius.only(topRight: Radius.circular(81))
            : const BorderRadius.only(topLeft: Radius.circular(81)),
        color: pureWhite,
      ),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 46, bottom: 82),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: primaryColor),
          ),
          const SizedBox(
            height: 38,
          ),
          Text(
            desc,
            style: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(color: primaryColor),
          ),
          const SizedBox(
            height: 52,
          ),
          Expanded(child: Container()),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: primaryColor,
                    dotColor: const Color.fromRGBO(20, 39, 155, .3),
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 6,
                  ),
                ),
                PrimaryClrBtn(null, goIcon, () {}),
              ],
            ),
          )
        ],
      ),
    );
  }
}
