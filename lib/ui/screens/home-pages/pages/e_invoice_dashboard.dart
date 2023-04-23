import 'dart:math';

import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dashboard_cards_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class EInvoiceDashboardFragment extends StatelessWidget {
  const EInvoiceDashboardFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            TopRow(),
            const SizedBox(
              height: 42,
            ),
            Cards(),
            const SizedBox(
              height: 10,
            ),
            Customers(),
            const SizedBox(
              height: 10,
            ),
            Documents(),
            const SizedBox(
              height: 40,
            ),
          ],
        )
      ],
    );
  }
}

class DonutDataItem {
  final double value;
  final Color color;
  final String label;
  DonutDataItem(this.value, this.color, this.label);
}

class Documents extends StatelessWidget {
  final Map<String, double> _list = {
    '': 60,
    ' ': 40,
  };
  Documents({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            appTxt(context).eInvoiceDashboardAcceptedDocumentsTxt,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).primaryColor),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 40,
          ),
          PieChart(
            dataMap: _list,
            ringStrokeWidth: 40,
            chartRadius: MediaQuery.of(context).size.width / 3,
            chartType: ChartType.ring,
            baseChartColor: Theme.of(context).primaryColor,
            colorList: [Theme.of(context).primaryColor, secondaryColor],
            chartValuesOptions: const ChartValuesOptions(
              showChartValuesInPercentage: true,
              showChartValuesOutside: true,
            ),
            legendOptions: const LegendOptions(showLegends: false),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(180)),
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
              Text(
                '${appTxt(context).eInvoiceTxt} (${_list['']}%)',
                style: Theme.of(context)
                    .textTheme
                    .labelSmall!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Customers extends StatelessWidget {
  Map<String, double> dataMap = {
    'سي باك لمواد التعبئة والتغليف': 86.0,
    'شركة العلمين لصناعة الكرتون المضلع': 13,
  };
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appTxt(context)
                    .eInvoiceDashboardTopCustomersTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Text(
                appTxt(context).moreTxt,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          // pieChart
          PieChart(
            dataMap: dataMap,
            chartRadius: MediaQuery.of(context).size.width / 2,
            legendOptions: LegendOptions(
                legendPosition: LegendPosition.bottom,
                legendTextStyle: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).primaryColor)),
            chartValuesOptions: ChartValuesOptions(
                showChartValuesInPercentage: true,
                chartValueStyle: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).primaryColor)),
          )
        ],
      ),
    );
  }
}

class Cards extends StatefulWidget {
  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  late PageController _pageController;
  int _activeCard = 0;
  List<Color> cardsBG = [
    greenCardBGClr,
    darkRedCardBGClr,
    purpleCardBGClr,
    lightRedCardBGClr
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: .75);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double calcAngle(int index, PageController controller, BuildContext context) {
    double value = 0.0;
    if (controller.position.haveDimensions) {
      value = index - (_pageController.page ?? 0);
      value = (value * .07).clamp(-1, 1);
    }
    return isRTL(context) ? -value : value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height/4,
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  _activeCard = index;
                });
              },
              controller: _pageController,
              children: [
                AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = calcAngle(0, _pageController, context);
                    return Transform.rotate(
                      angle: pi * value,
                      child: DashboardCardModel(
                          cardTitle: appTxt(context)
                              .eInvoiceDashboardCardValidTitle,
                          cardColor: greenCardBGClr,
                          titleColor: greenCardTitleClr,
                          dataColor: greenCardDataClr,
                          progressColor: greenCardProgressClr,
                          numOfDocuments: 19,
                          total: 12000,
                          taxes: 1200,
                          progressWidth: 100,
                          cardIcon: greenDBCardIcon),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = calcAngle(1, _pageController, context);
                    return Transform.rotate(
                      angle: pi * value,
                      child: DashboardCardModel(
                          cardTitle: appTxt(context)
                              .eInvoiceDashboardCardInvalidTitle,
                          cardColor: darkRedCardBGClr,
                          titleColor: pureWhite,
                          dataColor: pureWhite,
                          progressColor: darkRedCardProgressClr,
                          numOfDocuments: 19,
                          total: 12000,
                          taxes: 1200,
                          progressWidth: 100,
                          cardIcon: darkRedDBCardIcon),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = calcAngle(2, _pageController, context);
                    return Transform.rotate(
                      angle: pi * value,
                      child: DashboardCardModel(
                          cardTitle: appTxt(context)
                              .eInvoiceDashboardCardCancelledTitle,
                          cardColor: purpleCardBGClr,
                          titleColor: pureWhite,
                          dataColor: pureWhite,
                          progressColor: purpleCardProgressClr,
                          numOfDocuments: 19,
                          total: 12000,
                          taxes: 1200,
                          progressWidth: 100,
                          cardIcon: purpleDBCardIcon),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = calcAngle(3, _pageController, context);
                    return Transform.rotate(
                      angle: pi * value,
                      child: DashboardCardModel(
                          cardTitle: appTxt(context)
                              .eInvoiceDashboardCardRejectedTitle,
                          cardColor: lightRedCardBGClr,
                          titleColor: lightRedCardTitleClr,
                          dataColor: lightRedCardTitleClr,
                          progressColor: lightRedCardProgressClr,
                          numOfDocuments: 19,
                          total: 12000,
                          taxes: 1200,
                          progressWidth: 100,
                          cardIcon: lightRedDBCardIcon),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24,),
          SizedBox(
            height: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                  4,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _pageController.animateToPage(index,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            });
                          },
                          child: CircleAvatar(
                            radius: _activeCard == index ? 12 : 5,
                            backgroundColor: cardsBG[index],
                          ),
                        ),
                      )),
            ),
          )
        ],
      ),
    );
  }
}

class TopRow extends StatefulWidget {
  @override
  State<TopRow> createState() => _TopRowState();
}

class _TopRowState extends State<TopRow> {
  final dropDownItems = [10, 20, 30, 40, 50, 100];
  String? defaultValue = '10';
  DropdownMenuItem<String> buildMenuItem(String item, BuildContext context) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appTxt(context).eInvoiceDashboardTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                appTxt(context).eInvoiceDashboardDesc,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          Container(
            width: 45,
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 1),
              borderRadius:
                  const BorderRadius.all(Radius.circular(cornersRadiusConst)),
            ),
            child: DropdownButton<String>(
              items: dropDownItems
                  .map((e) => buildMenuItem(e.toString(), context))
                  .toList(),
              onChanged: (selected) {
                setState(() {
                  defaultValue = selected;
                });
              },
              icon: Icon(
                Icons.keyboard_arrow_down_sharp,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              value: defaultValue,
            ),
          ),
        ],
      ),
    );
  }
}
