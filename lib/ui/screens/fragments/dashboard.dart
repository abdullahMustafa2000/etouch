import 'dart:async';
import 'dart:math';
import 'package:etouch/api/api_models/dashboard_response.dart';
import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/api_response.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/classes/base_api_response.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dashboard_cards_model.dart';
import 'package:etouch/ui/elements/request_api_widget.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pie_chart/pie_chart.dart';

class EInvoiceDashboardFragment extends StatefulWidget {
  const EInvoiceDashboardFragment({Key? key, required this.loginResponse})
      : super(key: key);
  final LoginResponse loginResponse;

  @override
  State<EInvoiceDashboardFragment> createState() =>
      _EInvoiceDashboardFragmentState();
}

class _EInvoiceDashboardFragmentState extends State<EInvoiceDashboardFragment> {
  late Future<APIResponse<DashboardResponse>> _dashboardResponse;

  MyApiServices get services => GetIt.I<MyApiServices>();

  Future<APIResponse<DashboardResponse>> _getDashboardFuture(
          String token, int branchId) async =>
      await services.getDashboard(token, branchId: branchId);

  @override
  void initState() {
    _dashboardResponse = _getDashboardFuture(widget.loginResponse.token!,
        widget.loginResponse.userBranches!.first.getId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RequestAPIWidget<APIResponse<DashboardResponse>>(
      request: _dashboardResponse,
      onSuccessfulResponse: (snap) {
        DashboardResponse? response = snap.data?.data;
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              TopRow(
                branches: widget.loginResponse.userBranches,
                branchChanged: (branchId) {
                  if (branchId != null) {
                    _dashboardResponse = _getDashboardFuture(
                        widget.loginResponse.token!, branchId);
                    setState(() {});
                  }
                },
              ),
              const SizedBox(
                height: 42,
              ),
              !snap.hasData
                  ? const CircularProgressIndicator()
                  : Cards(
                      dashboardResponse: response,
                    ),
              const SizedBox(
                height: 10,
              ),
              !snap.hasData
                  ? const CircularProgressIndicator()
                  : TopCustomers(
                      dashboardResponse: response,
                    ),
              const SizedBox(
                height: 10,
              ),
              !snap.hasData
                  ? const CircularProgressIndicator()
                  : Documents(dashboardResponse: response),
              const SizedBox(
                height: 42,
              ),
            ],
          ),
        );
      },
    );
  }
}

class Documents extends StatelessWidget {
  final Map<String, double> _list = {
    '': 0,
  };
  final DashboardResponse? dashboardResponse;
  Documents({Key? key, required this.dashboardResponse}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    for (Statistics item in dashboardResponse?.invoiceTypes ?? []) {
      _list[item.key ?? ''] = item.value ?? 0;
    }
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
                '${appTxt(context).eInvoiceTxt} (${_list['فاتورة']}%)',
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

class TopCustomers extends StatelessWidget {
  final Map<String, double> data = <String, double>{};
  final DashboardResponse? dashboardResponse;
  TopCustomers({Key? key, required this.dashboardResponse}) : super(key: key);
  final colorList = <Color>[
    const Color(0xff0984e3),
    const Color(0xfffdcb6e),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  @override
  Widget build(BuildContext context) {
    for (Statistics item in dashboardResponse?.topReceivers ?? []) {
      data[item.key ?? 'no name'] = item.value ?? 0;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appTxt(context).eInvoiceDashboardTopCustomersTitle,
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
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          // pieChart
          PieChart(
            dataMap: data,
            colorList: colorList,
            chartRadius: MediaQuery.of(context).size.width / 2,
            legendOptions: LegendOptions(
              legendPosition: LegendPosition.bottom,
              showLegends: true,
              legendTextStyle: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).primaryColor),
            ),
            chartValuesOptions: ChartValuesOptions(
              showChartValuesInPercentage: false,
              chartValueStyle: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.black),
            ),
            //emptyColor: loginPlaceholderLightClr,
          ),
        ],
      ),
    );
  }
}

class Cards extends StatefulWidget {
  const Cards({Key? key, required this.dashboardResponse}) : super(key: key);
  final DashboardResponse? dashboardResponse;
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
  SubmitTypes? _valid;
  SubmitTypes? _inValid;
  SubmitTypes? _cancelled;
  SubmitTypes? _rejected;
  DashboardResponse? _response;
  @override
  void initState() {
    _response = widget.dashboardResponse;
    _valid = _response?.valid;
    _inValid = _response?.invalid;
    _rejected = _response?.rejected;
    _cancelled = _response?.cancelled;
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
            height: MediaQuery.of(context).size.height / 4,
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
                          cardTitle:
                              appTxt(context).eInvoiceDashboardCardValidTitle,
                          cardColor: greenCardBGClr,
                          titleColor: greenCardTitleClr,
                          dataColor: greenCardDataClr,
                          progressColor: greenCardProgressClr,
                          numOfDocuments: _valid?.count ?? 0,
                          total: _valid?.total ?? 0,
                          taxes: _valid?.tax ?? 0,
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
                          cardTitle:
                              appTxt(context).eInvoiceDashboardCardInvalidTitle,
                          cardColor: darkRedCardBGClr,
                          titleColor: pureWhite,
                          dataColor: pureWhite,
                          progressColor: darkRedCardProgressClr,
                          numOfDocuments: _inValid?.count ?? 0,
                          total: _inValid?.total ?? 0,
                          taxes: _inValid?.tax ?? 0,
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
                          numOfDocuments: _cancelled?.count ?? 0,
                          total: _cancelled?.total ?? 0,
                          taxes: _cancelled?.tax ?? 0,
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
                          numOfDocuments: _rejected?.count ?? 0,
                          total: _rejected?.total ?? 0,
                          taxes: _rejected?.tax ?? 0,
                          progressWidth: 100,
                          cardIcon: lightRedDBCardIcon),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
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
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopRow extends StatefulWidget {
  const TopRow({required this.branchChanged, this.branches, Key? key})
      : super(key: key);
  final List<BaseAPIObject>? branches;
  final Function(int?) branchChanged;
  @override
  State<TopRow> createState() => _TopRowState();
}

class _TopRowState extends State<TopRow> {
  BaseAPIObject? defaultValue;

  DropdownMenuItem<BaseAPIObject> buildMenuItem(
          BaseAPIObject branch, BuildContext context) =>
      DropdownMenuItem<BaseAPIObject>(
        value: branch,
        child: Text(
          branch.getName.toString(),
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      );
  @override
  void initState() {
    defaultValue = widget.branches?.first;
    super.initState();
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            decoration: BoxDecoration(
              border:
                  Border.all(color: Theme.of(context).primaryColor, width: 1),
              borderRadius:
                  const BorderRadius.all(Radius.circular(cornersRadiusConst)),
            ),
            child: DropdownButton<BaseAPIObject>(
              items: widget.branches
                  ?.map((e) => buildMenuItem(e, context))
                  .toList(),
              onChanged: (selected) {
                setState(() {
                  widget.branchChanged(selected?.getId);
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
