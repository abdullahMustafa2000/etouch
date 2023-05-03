import 'dart:async';
import 'dart:math';
import 'package:etouch/api/api_models/dashboard/submitted_doc_statuses.dart';
import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/api_models/map_response.dart';
import 'package:etouch/api/api_response.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/dashboard_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dashboard_cards_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import '../../../../api/api_models/dashboard/dashboard_response.dart';

class EInvoiceDashboardFragment extends StatelessWidget {
  EInvoiceDashboardFragment({Key? key, required this.loginResponse})
      : super(key: key);
  LoginResponse loginResponse;
  MyApiServices get services => GetIt.I<MyApiServices>();
  Future<APIResponse<DashboardResponse>> _getDashboardFuture(
      String token) async {
    return await services.getDashboard(token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDashboardFuture(loginResponse.token),
        builder: (context, AsyncSnapshot<APIResponse<DashboardResponse>> snap) {
          bool hasData = true;
          bool waiting = false;
          DashboardResponse? response = snap.data?.data;
          return ListView(
            children: [
              !waiting && !hasData
                  ? Center(
                      child: Text(
                      appTxt(context).checkInternetMessage,
                      style: txtTheme(context)
                          .displayLarge!
                          .copyWith(color: appTheme(context).primaryColor),
                    ))
                  : Column(
                      children: [
                        TopRow(),
                        const SizedBox(
                          height: 42,
                        ),
                        waiting
                            ? const CircularProgressIndicator()
                            : Cards(
                                dashboardResponse: response,
                                token: loginResponse.token,
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        waiting
                            ? const CircularProgressIndicator()
                            : TopCustomers(
                                dashboardResponse: response,
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        waiting
                            ? const CircularProgressIndicator()
                            : Documents(dashboardResponse: response),
                        const SizedBox(
                          height: 42,
                        ),
                      ],
                    ),
            ],
          );
        });
  }
}

class Documents extends StatelessWidget {
  final Map<String, double> _list = {
    '': 100,
  };
  DashboardResponse? dashboardResponse;
  Documents({Key? key, required this.dashboardResponse}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    for (APIMapResponse customer in dashboardResponse?.invoiceTypes ?? []) {
      _list[customer.key!] = customer.value!;
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

class TopCustomers extends StatelessWidget {
  Map<String, double> data = {'': 0};
  DashboardResponse? dashboardResponse;
  TopCustomers({required this.dashboardResponse});
  final colorList = <Color>[
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xfffd79a8),
    const Color(0xffe17055),
    const Color(0xff6c5ce7),
  ];

  @override
  Widget build(BuildContext context) {
    for (APIMapResponse customer in dashboardResponse?.topReceivers ?? []) {
      data[customer.key!] = customer.value!;
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
              emptyColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}

class Cards extends StatefulWidget {
  Cards({required this.dashboardResponse, required this.token});
  DashboardResponse? dashboardResponse;
  String token;
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
  SubmissionsStatuses? _valid, _invalid, _rejected, _cancelled;
  DashboardResponse? _response;
  @override
  void initState() {
    _response = widget.dashboardResponse;
    _valid = _response?.valid;
    _invalid = _response?.invalid;
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
    var dashboardProvider = context.watch<DashboardProvider>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<APIResponse<DashboardResponse>>(
        future:
            getDashboardInfo(widget.token, dashboardProvider.numOfDocuments),
        builder: (context, AsyncSnapshot<APIResponse<DashboardResponse>> snap) {
          if (snap.hasData) {
            DashboardResponse? response = snap.data?.data;
            _valid = response?.valid;
            _invalid = response?.invalid;
            _rejected = response?.rejected;
            _cancelled = response?.cancelled;
            return Column(
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
                                cardTitle: appTxt(context)
                                    .eInvoiceDashboardCardValidTitle,
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
                                cardTitle: appTxt(context)
                                    .eInvoiceDashboardCardInvalidTitle,
                                cardColor: darkRedCardBGClr,
                                titleColor: pureWhite,
                                dataColor: pureWhite,
                                progressColor: darkRedCardProgressClr,
                                numOfDocuments: _invalid?.count ?? 0,
                                total: _invalid?.total ?? 0,
                                taxes: _invalid?.tax ?? 0,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _pageController.animateToPage(index,
                                        duration:
                                            const Duration(milliseconds: 500),
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
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  MyApiServices get services => GetIt.I<MyApiServices>();

  Future<APIResponse<DashboardResponse>> getDashboardInfo(
      token, int numOfDocuments) async {
    return await services.getDashboard(token, s: numOfDocuments);
  }
}

class TopRow extends StatefulWidget {
  @override
  State<TopRow> createState() => _TopRowState();
}

class _TopRowState extends State<TopRow> {
  final dropDownItems = [10, 20, 30, 40, 50, 100];
  int? defaultValue = 10;
  DropdownMenuItem<int> buildMenuItem(int item, BuildContext context) =>
      DropdownMenuItem<int>(
        value: item,
        child: Text(
          item.toString(),
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      );

  @override
  Widget build(BuildContext context) {
    DashboardProvider dashboardProvider =
        Provider.of<DashboardProvider>(context);
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
            child: DropdownButton<int>(
              items:
                  dropDownItems.map((e) => buildMenuItem(e, context)).toList(),
              onChanged: (selected) {
                setState(() {
                  dashboardProvider.updateNumOfDocuments(selected!);
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
