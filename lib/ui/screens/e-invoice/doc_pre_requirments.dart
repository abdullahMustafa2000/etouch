import 'package:etouch/api/api_models/sales_order.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/ui/elements/dropdown_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../../main.dart';
import '../../constants.dart';
import '../../themes/themes.dart';

class OrderPreRequirementsWidget extends StatefulWidget {
  const OrderPreRequirementsWidget(
      {Key? key,
      required this.branchesList,
      required this.services,
      required this.token,
      required this.salesOrder})
      : super(key: key);
  final List<BaseAPIObject>? branchesList;
  final MyApiServices services;
  final String token;
  final SalesOrder salesOrder;
  @override
  State<OrderPreRequirementsWidget> createState() =>
      _OrderPreRequirementsWidgetState();
}

class _OrderPreRequirementsWidgetState
    extends State<OrderPreRequirementsWidget> {
  List<BaseAPIObject>? _warehouses, _treasuries, _customers;
  late EInvoiceDocProvider _docProvider;
  late Future<List<BaseAPIObject>?> _warehousesFuture,
      _customersFuture,
      _treasuriesFuture;
  @override
  void initState() {
    _warehousesFuture =
        _getWarehouses(widget.salesOrder.branchId!, widget.token);
    _customersFuture =
        _getCustomers(widget.salesOrder.branchId!, widget.token);
    _treasuriesFuture =
        _getTreasuries(widget.salesOrder.branchId!, widget.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _docProvider = Provider.of<EInvoiceDocProvider>(context);
    SalesOrder salesOrder = _docProvider.salesOrder;
    return FutureBuilder<List<List<BaseAPIObject>?>>(
      future:
          Future.wait([_warehousesFuture, _treasuriesFuture, _customersFuture]),
      builder: (context, AsyncSnapshot<List<List<BaseAPIObject>?>> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          //progress bar
          return _waitingDataView();
        } else {
          if (snap.hasData) {
            _docProvider.salesOrder.warehouseId = snap.data?.first?.first.getId;
            _docProvider.salesOrder.treasuryId = snap.data?[1]?.first.getId;
            _docProvider.salesOrder.customerId = snap.data?.last?.first.getId;
            //draw view
            return _successfulDataView(snap);
          } else {
            //check internet
            return _failureDataView(context);
          }
        }
      },
    );
  }

  Widget _successfulDataView(AsyncSnapshot<List<List<BaseAPIObject>?>> snap) =>
      Container(
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
              dataList1: widget.branchesList,
              selectedItem1: firstOrDef(widget.branchesList, _docProvider.salesOrder.branchId),
              selectedVal1: (BaseAPIObject? val1) {
                _docProvider.updateBranchId(val1?.getId);
              },
              label2: appTxt(context).inventoryTxt,
              dataList2: snap.data?.first,//warehouses
              selectedVal2: (BaseAPIObject? val2) {
                setState(() {});
                _docProvider.updateWarehouseId(val2?.getId);
              },
              selectedItem2:
                  firstOrDef(_warehouses, _docProvider.salesOrder.warehouseId),
            ),
            const SizedBox(
              height: 24,
            ),
            PreRequirementsRow(
              label1: appTxt(context).currencyTxt,
              dataList1: _docProvider.companyCurrencies,
              selectedVal1: (BaseAPIObject? val1) {
                _docProvider.salesOrder.currencyId = val1?.getId;
              },
              selectedItem1: firstOrDef(_docProvider.companyCurrencies,
                  _docProvider.salesOrder.currencyId),
              label2: appTxt(context).treasuryTxt,
              dataList2: snap.data?[1],
              selectedVal2: (BaseAPIObject? val2) {
                _docProvider.salesOrder.treasuryId = val2?.getId;
              },
              selectedItem2:
                  firstOrDef(_treasuries, _docProvider.salesOrder.treasuryId),
            ),
            const SizedBox(
              height: 24,
            ),
            RequiredInfoDesign(
              label: appTxt(context).customerTxt,
              dataList: snap.data?.last,
              selectedVal: (BaseAPIObject? val) {
                _docProvider.salesOrder.customerId = val?.getId;
              },
              selectedItem:
                  firstOrDef(_customers, _docProvider.salesOrder.customerId),
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

  Widget _waitingDataView() => const Center(child: CircularProgressIndicator());

  Widget _failureDataView(BuildContext context) => Center(
        child: Text(appTxt(context).checkInternetMessage),
      );

  Future<List<BaseAPIObject>?> _getCustomers(
          int branchId, String token) async =>
      (await widget.services.getCustomersList(branchId, token)).data;

  Future<List<BaseAPIObject>?> _getWarehouses(
          int branchId, String token) async =>
      (await widget.services.getWarehousesList(branchId, token)).data;

  Future<List<BaseAPIObject>?> _getTreasuries(
          int branchId, String token) async =>
      (await widget.services.getTreasuriesList(branchId, token)).data;

  Future<bool> _onBranchSelected(int? branchId, String token) async {
    branchId ??= widget.branchesList?[0].getId;
    //get customers
    _customers = await _getCustomers(branchId!, token);
    //get warehouses
    _warehouses = await _getWarehouses(branchId, token);
    //get treasuries
    _treasuries = await _getTreasuries(branchId, token);
    //update salesOrder branchId
    _docProvider.updateBranchId(branchId);
    _docProvider.updateWarehouseId(
        _warehouses != null ? _warehouses!.first.getId : null);
    return true;
  }

  BaseAPIObject? firstOrDef(List<BaseAPIObject>? lst, int? id) {
    if (id == null && lst != null) return lst.first;
    lst?.firstWhere((element) => element.id == id) ?? lst?.first;
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
