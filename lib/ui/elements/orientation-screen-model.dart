import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/primary-btn-model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OrientationModel extends StatefulWidget {
  OrientationModel(
      {Key? key,
      required this.title,
      required this.desc,
      required this.lottiePath,
      required this.controller,
      required this.onNextClick})
      : super(key: key);
  String lottiePath;
  String title, desc;
  PageController controller;
  Function onNextClick;

  @override
  State<OrientationModel> createState() => _OrientationModelState();
}

class _OrientationModelState extends State<OrientationModel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Lottie.asset(widget.lottiePath)),
          Expanded(
              child: DiscussionWidget(
            title: widget.title,
            desc: widget.desc,
            pageController: widget.controller,
            onNextClicked: () {
              widget.onNextClick();
            },
          )),
        ],
      ),
    );
  }
}

class DiscussionWidget extends StatefulWidget {
  DiscussionWidget(
      {Key? key,
      required this.title,
      required this.desc,
      required this.pageController,
      required this.onNextClicked})
      : super(key: key);
  String title;
  String desc;
  PageController pageController;
  Function onNextClicked;

  @override
  State<DiscussionWidget> createState() => _DiscussionWidgetState();
}

class _DiscussionWidgetState extends State<DiscussionWidget> {
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
      child: Directionality(
        textDirection: isRTL(context)?TextDirection.rtl:TextDirection.ltr,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(color: primaryColor),
            ),
            const SizedBox(
              height: 38,
            ),
            Text(
              widget.desc,
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
                    controller: widget.pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: primaryColor,
                      dotColor: const Color.fromRGBO(20, 39, 155, .3),
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 6,
                    ),
                  ),
                  PrimaryClrBtnModel(
                    color: primaryColor,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          appTxt(context).nextTxt,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: pureWhite, fontFamily: almarai),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Icon(
                          Icons.navigate_next_sharp,
                          color: pureWhite,
                        ),
                      ],
                    ),
                    onPressed: () {
                      widget.onNextClicked();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
