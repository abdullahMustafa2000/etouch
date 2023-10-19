import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/api_models/sales_order.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/ui/elements/dropdown_model.dart';
import 'package:etouch/ui/elements/request_api_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../../../../../main.dart';
import '../../../../../constants.dart';
import '../../../../../themes/themes.dart';

class OrderPreRequirementsWidget extends StatefulWidget {
  const OrderPreRequirementsWidget(
      {Key? key,
      required this.salesOrder,
      required this.loginResponse,
      required this.service})
      : super(key: key);
  final SalesOrder salesOrder;
  final LoginResponse loginResponse;
  final MyApiServices service;
  @override
  State<OrderPreRequirementsWidget> createState() =>
      _OrderPreRequirementsWidgetState();
}

class _OrderPreRequirementsWidgetState
    extends State<OrderPreRequirementsWidget> {
  late Future<List<BaseAPIObject>?> _currenciesFut;
  late Future<List<BaseAPIObject>?> _treasuriesFut,
      _customersFut,
      _warehousesFut;
  @override
  void initState() {
    _currenciesFut = _getCurrencies();
    widget.salesOrder.branch = widget.loginResponse.userBranches!.first;
    _treasuriesFut = _getTreasuries(
        widget.salesOrder.branch?.getId ?? 0, widget.loginResponse.token ?? '');
    _customersFut = _getCustomers(
        widget.salesOrder.branch?.getId ?? 0, widget.loginResponse.token ?? '');
    _warehousesFut = _getWarehouses(
        widget.salesOrder.branch?.getId ?? 0, widget.loginResponse.token ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RequestAPIWidget<List<List<BaseAPIObject>?>>(
        request: Future.wait(
            [_warehousesFut, _currenciesFut, _treasuriesFut, _customersFut]),
        onSuccessfulResponse: (snap) {
          _initData(snap);
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.all(Radius.circular(cornersRadiusConst)),
              gradient: LinearGradient(
                  colors: [accentColor, primaryColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Column(
              children: [
                Text(
                  appTxt(context).createDocumentTitle,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: pureWhite),
                ),
                const SizedBox(
                  height: 24,
                ),
                PreRequirementsRow(
                  label1: appTxt(context).branchTxt,
                  dataList1: widget.loginResponse.userBranches,
                  selectedItem1: widget.salesOrder.branch,
                  selectedVal1: (BaseAPIObject? val1) {
                    widget.salesOrder.branch = val1;
                    context
                        .read<EInvoiceDocProvider>()
                        .updateBranchId(val1?.getId ?? -1);
                  },
                  label2: appTxt(context).inventoryTxt,
                  dataList2: snap.data?[0], //warehouses
                  selectedVal2: (BaseAPIObject? val2) {
                    widget.salesOrder.warehouse = val2;
                    context
                        .read<EInvoiceDocProvider>()
                        .updateWarehouseId(val2?.getId ?? 0);
                  },
                  selectedItem2: widget.salesOrder.warehouse,
                ),
                const SizedBox(
                  height: 24,
                ),
                PreRequirementsRow(
                  label1: appTxt(context).currencyTxt,
                  dataList1: snap.data?[1],
                  selectedVal1: (BaseAPIObject? val1) {
                    widget.salesOrder.currency = val1;
                  },
                  selectedItem1: widget.salesOrder.currency,
                  label2: appTxt(context).treasuryTxt,
                  dataList2: snap.data?[2],
                  selectedVal2: (BaseAPIObject? val2) {
                    widget.salesOrder.treasury = val2;
                  },
                  selectedItem2: widget.salesOrder.treasury,
                ),
                const SizedBox(
                  height: 24,
                ),
                RequiredInfoDesign(
                  label: appTxt(context).customerTxt,
                  dataList: snap.data?[3],
                  selectedVal: (BaseAPIObject? val) {
                    widget.salesOrder.customer = val;
                  },
                  selectedItem: widget.salesOrder.customer,
                ),
                const SizedBox(
                  height: 18,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: pureWhite,
                ),
                const SizedBox(
                  height: 18,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${appTxt(context).dateTxt}:',
                          style: txtTheme(context)
                              .labelLarge!
                              .copyWith(color: pureWhite),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          '${appTxt(context).orderNumTxt}:',
                          style: txtTheme(context)
                              .labelLarge!
                              .copyWith(color: pureWhite),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateTime.now().toString(),
                          style: txtTheme(context)
                              .labelMedium!
                              .copyWith(color: pureWhite),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          'null',
                          style: txtTheme(context)
                              .labelMedium!
                              .copyWith(color: pureWhite),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<List<BaseAPIObject>?> _getCurrencies() async {
    return (await widget.service.getCurrenciesList(
            widget.loginResponse.companyId ?? 0,
            widget.loginResponse.token ?? ''))
        .data;
  }

  Future<List<BaseAPIObject>?> _getCustomers(
          int branchId, String token) async =>
      (await widget.service.getCustomersList(branchId, token)).data;

  Future<List<BaseAPIObject>?> _getWarehouses(
          int branchId, String token) async =>
      (await widget.service.getWarehousesList(branchId, token)).data;

  Future<List<BaseAPIObject>?> _getTreasuries(
          int branchId, String token) async =>
      (await widget.service.getTreasuriesList(branchId, token)).data;

  void _initData(AsyncSnapshot<List<List<BaseAPIObject>?>> snap) {
    widget.salesOrder.warehouse = snap.data?[0]?.first;
    widget.salesOrder.currency = snap.data?[1]?.first;
    widget.salesOrder.treasury = snap.data?[2]?.first;
    widget.salesOrder.customer = snap.data?[3]?.first;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<EInvoiceDocProvider>().updateWarehouseId(widget.salesOrder.warehouse?.getId ?? 0);
    });
  }
}

class PreRequirementsRow extends StatelessWidget {
  const PreRequirementsRow(
      {Key? key,
      required this.label1,
      required this.dataList1,
      required this.label2,
      required this.dataList2,
      required this.selectedVal1,
      required this.selectedVal2,
      required this.selectedItem1,
      required this.selectedItem2})
      : super(key: key);
  final String label1, label2;
  final List<BaseAPIObject>? dataList1, dataList2;
  final Function selectedVal1, selectedVal2;
  final BaseAPIObject? selectedItem1, selectedItem2;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RequiredInfoDesign(
            label: label1,
            dataList: dataList1,
            selectedVal: (BaseAPIObject? val) {
              selectedVal1(val);
            },
            selectedItem: selectedItem1,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: RequiredInfoDesign(
            label: label2,
            dataList: dataList2,
            selectedVal: (BaseAPIObject? val) {
              selectedVal2(val);
            },
            selectedItem: selectedItem2,
          ),
        ),
      ],
    );
  }
}

class RequiredInfoDesign extends StatelessWidget {
  const RequiredInfoDesign(
      {Key? key,
      required this.label,
      required this.dataList,
      required this.selectedVal,
      required this.selectedItem})
      : super(key: key);
  final String label;
  final List<BaseAPIObject>? dataList;
  final Function selectedVal;
  final BaseAPIObject? selectedItem;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: const Color.fromRGBO(218, 198, 248, 1)),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: DropDownMenuModel(
            defValue: dataList != null && dataList!.isNotEmpty
                ? dataList!.first
                : null,
            dataList: dataList,
            selectedVal: (BaseAPIObject? val) {
              selectedVal(val);
            }, /*AppLocalizations.of(context)!.chooseFromDropDownTxt*/
          ),
        ),
      ],
    );
  }
}
