import 'package:bottom_picker/bottom_picker.dart';
import 'package:etouch/api/api_models/currencies_reponse.dart';
import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/api_models/sales_order.dart';
import 'package:etouch/api/api_response.dart';
import 'package:etouch/api/list_requests_api_builder.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/ui/elements/dropdown_model.dart';
import 'package:etouch/ui/elements/editable_data.dart';
import 'package:etouch/api/api_requests_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../businessLogic/classes/base_api_response.dart';
import '../../../../../main.dart';
import '../../../constants.dart';
import '../../../themes/themes.dart';

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
  late Future<APIResponse<List<BaseAPIObject>?>> _currenciesFut,
      _treasuriesFut,
      _customersFut,
      _warehousesFut;

  late bool _created;
  @override
  void initState() {
    initAPICalls();
    _created = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListAPIWidgets<List<APIResponse<List<BaseAPIObject>?>>>(
      request: Future.wait(
          [_warehousesFut, _currenciesFut, _treasuriesFut, _customersFut]),
      onSuccessfulResponse: (snap) {
        if (!_created) {
          _created = true;
          _initData(snap.data);
        }
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
                ///Branches list
                label1: appTxt(context).branchTxt,
                dataList1: widget.loginResponse.userBranches,
                selectedItem1: widget.salesOrder.branch,
                selectedVal1: (BaseAPIObject? val1) {
                  onBranchWarehouseChanged();
                  widget.salesOrder.branch = val1;
                  context
                      .read<EInvoiceDocProvider>()
                      .updateBranchId(val1?.getId ?? -1);
                },

                ///Warehouses list
                label2: appTxt(context).inventoryTxt,
                dataList2: snap.data?[0].data, //warehouses
                selectedVal2: (BaseAPIObject? val2) {
                  onBranchWarehouseChanged();
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
                ///currencies list
                label1: appTxt(context).currencyTxt,
                dataList1: snap.data?[1].data,
                selectedItem1: widget.salesOrder.currency,
                selectedVal1: (CurrenciesResponse? val1) {
                  widget.salesOrder.currency = val1;
                },

                ///treasuries list
                label2: appTxt(context).treasuryTxt,
                dataList2: snap.data?[2].data,
                selectedVal2: (BaseAPIObject? val2) {
                  widget.salesOrder.treasury = val2;
                },
                selectedItem2: widget.salesOrder.treasury,
              ),
              const SizedBox(
                height: 24,
              ),
              RequiredInfoDesign(
                ///customers list
                label: appTxt(context).customerTxt,
                dataList: snap.data?[3].data,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DateTimePickerRow(
                    salesOrder: widget.salesOrder,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  OrderNumberRow(
                    salesOrder: widget.salesOrder,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void initAPICalls() {
    _currenciesFut = _getCurrencies();
    widget.salesOrder.branch = widget.loginResponse.userBranches!.first;
    _treasuriesFut = _getTreasuries(
        widget.salesOrder.branch?.getId ?? 0, widget.loginResponse.token ?? '');
    _customersFut = _getCustomers(
        widget.salesOrder.branch?.getId ?? 0, widget.loginResponse.token ?? '');
    _warehousesFut = _getWarehouses(
        widget.salesOrder.branch?.getId ?? 0, widget.loginResponse.token ?? '');
  }

  Future<APIResponse<List<BaseAPIObject>?>> _getCurrencies() async {
    return (await widget.service.getCurrenciesList(
        widget.loginResponse.companyId ?? 0, widget.loginResponse.token ?? ''));
  }

  Future<APIResponse<List<BaseAPIObject>?>> _getCustomers(
          int branchId, String token) async =>
      await widget.service.getCustomersList(branchId, token);

  Future<APIResponse<List<BaseAPIObject>?>> _getWarehouses(
          int branchId, String token) async =>
      await widget.service.getWarehousesList(branchId, token);

  Future<APIResponse<List<BaseAPIObject>?>> _getTreasuries(
          int branchId, String token) async =>
      await widget.service.getTreasuriesList(branchId, token);

  void _initData(List<APIResponse<List<BaseAPIObject>?>>? data) {
    widget.salesOrder.warehouse = data?[0].data?.first;
    widget.salesOrder.currency = data?[1].data?.first;
    widget.salesOrder.treasury = data?[2].data?.first;
    widget.salesOrder.customer = data?[3].data?.first;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<EInvoiceDocProvider>()
          .updateWarehouseId(widget.salesOrder.warehouse?.getId ?? 0);
    });
  }

  void onBranchWarehouseChanged() {
    widget.salesOrder.onBranchWarehouseChange();
    context.read<EInvoiceDocProvider>().clearData();
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
            defValue: selectedItem,
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

class DateTimePickerRow extends StatefulWidget {
  const DateTimePickerRow({required this.salesOrder, Key? key})
      : super(key: key);
  final SalesOrder salesOrder;

  @override
  State<DateTimePickerRow> createState() => _DateTimePickerRowState();
}

class _DateTimePickerRowState extends State<DateTimePickerRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '${appTxt(context).dateTxt}:',
          style: txtTheme(context).labelLarge!.copyWith(color: pureWhite),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 18,
        ),
        Row(
          children: [
            Text(
              widget.salesOrder.orderDate.toString(),
              style: txtTheme(context).labelMedium!.copyWith(color: pureWhite),
            ),
            InkWell(
                onTap: () {
                  showDateTimePicker();
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                )),
          ],
        ),
      ],
    );
  }

  dynamic showDateTimePicker() => BottomPicker.dateTime(
        title: appTxt(context).dateTimePickerTitle,
        titleStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.black,
        ),
        onSubmit: (date) {
          setState(() {
            widget.salesOrder.orderDate = date as DateTime;
          });
        },
        onClose: () {},
        iconColor: Colors.black,
        initialDateTime: widget.salesOrder.orderDate,
        gradientColors: const [Color(0xfffdcbf1), Color(0xffe6dee9)],
      ).show(context);
}

class OrderNumberRow extends StatefulWidget {
  const OrderNumberRow({required this.salesOrder, Key? key}) : super(key: key);
  final SalesOrder salesOrder;

  @override
  State<OrderNumberRow> createState() => _OrderNumberRowState();
}

class _OrderNumberRowState extends State<OrderNumberRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '${appTxt(context).orderNumTxt}:',
          style: txtTheme(context).labelLarge!.copyWith(color: pureWhite),
        ),
        const SizedBox(
          height: 18,
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(cornersRadiusConst),
          ),
          child: EditableInputData(
              data: '',
              inputHint: appTxt(context).optional,
              onChange: (txt, isEmpty) {
                if (!isEmpty) {
                  widget.salesOrder.orderId = int.parse(txt);
                }
              },
              hasInitValue: false),
        ),
      ],
    );
  }
}
