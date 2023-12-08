import 'package:dropdown_search/dropdown_search.dart';
import 'package:etouch/api/api_models/sales_order.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/elements/editable_data.dart';
import 'package:etouch/ui/elements/api_requests_builder.dart';
import 'package:etouch/ui/elements/searchable_dropdown_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../api/api_models/tax_of_document_model.dart';
import '../../../../../businessLogic/classes/base_api_response.dart';
import '../../../elements/uneditable_data.dart';

class DocumentNumbers extends StatefulWidget {
  final String token;
  final MyApiServices services;
  final SalesOrder salesOrder;
  final int companyId;
  const DocumentNumbers(
      {Key? key,
      required this.services,
      required this.token,
      required this.salesOrder,
      required this.companyId})
      : super(key: key);

  @override
  State<DocumentNumbers> createState() => _DocumentNumbersState();
}

class _DocumentNumbersState extends State<DocumentNumbers> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Expanded(
        //       child: DiscountsAndTaxesWidget(
        //         services: widget.services,
        //         branchId: widget.salesOrder.branch?.getId,
        //         token: widget.token,
        //         salesOrder: widget.salesOrder,
        //         onTaxesChange: (lst) {
        //           widget.salesOrder.taxesAndDiscounts = lst;
        //           setState(() {});
        //         },
        //       ),
        //     ),
        //     PricesAndTotals(
        //       taxesAndDiscounts: widget.salesOrder.taxesAndDiscounts,
        //     ),
        //   ],
        // ),
        const SizedBox(
          height: 24,
        ),
        CashesWidget(
          services: widget.services,
          branchId: widget.salesOrder.branch?.getId,
          token: widget.token,
          salesOrder: widget.salesOrder,
          companyId: widget.companyId,
        ),
      ],
    );
  }
}

class CashesWidget extends StatefulWidget {
  const CashesWidget(
      {Key? key,
      required this.services,
      required this.branchId,
      required this.token,
      required this.salesOrder,
      required this.companyId})
      : super(key: key);
  final MyApiServices services;
  final int? branchId, companyId;
  final String? token;
  final SalesOrder salesOrder;
  @override
  State<CashesWidget> createState() => _CashesWidgetState();
}

class _CashesWidgetState extends State<CashesWidget> {
  late Future<List<BaseAPIObject>?> _paymentMethodsFut;
  @override
  void initState() {
    _paymentMethodsFut =
        _getPaymentMethods(widget.companyId!, widget.token ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            PaidCashesWidget(
              data: appTxt(context).paymentMethods,
              content: RequestAPIWidget<List<BaseAPIObject>?>(
                  request: _paymentMethodsFut,
                  onSuccessfulResponse: (snap) {
                    return SearchDropdownMenuModel(
                      dataList: snap.data,
                      onItemSelected: (BaseAPIObject? val) {
                        widget.salesOrder.paymentMethods = [];
                        widget.salesOrder.paymentMethods.add(val!);
                      },
                      selectedItem:
                          widget.salesOrder.paymentMethods.firstOrNull,
                    );
                  }),
            ),
            PaidCashesWidget(
              data: appTxt(context).paidAmount,
              content: EditableInputData(
                  data: '',
                  onChange: (String? val, bool isEmpty) {
                    double paidEntered = isEmpty ? 0 : double.parse(val!);
                    widget.salesOrder.paid = paidEntered;
                    context.read<EInvoiceDocProvider>().updatePaid(paidEntered);
                  },
                  hasInitValue: true),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appTxt(context).restOfAmount,
              style: txtTheme(context)
                  .titleMedium!
                  .copyWith(color: appTheme(context).primaryColor),
            ),
            Text(
              (context.watch<EInvoiceDocProvider>().docTotalAmount -
                      context.watch<EInvoiceDocProvider>().paid)
                  .toString(),
              style: txtTheme(context)
                  .headlineLarge!
                  .copyWith(color: appTheme(context).primaryColor),
            ),
          ],
        ),
      ],
    );
  }

  Future<List<BaseAPIObject>?> _getPaymentMethods(
      int companyId, String token) async {
    return (await widget.services.getPaymentMethodsList(companyId, token)).data;
  }
}

class PaidCashesWidget extends StatelessWidget {
  const PaidCashesWidget({Key? key, required this.data, required this.content})
      : super(key: key);
  final String data;
  final Widget content;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            UnEditableData(data: data),
            const SizedBox(
              height: 6,
            ),
            content,
          ],
        ),
      ),
    );
  }
}

class DiscountsAndTaxesWidget extends StatefulWidget {
  final MyApiServices services;
  final int? branchId;
  final String token;
  final SalesOrder salesOrder;
  final Function(List<DocumentTaxesModel>) onTaxesChange;
  const DiscountsAndTaxesWidget(
      {Key? key,
      required this.services,
      required this.branchId,
      required this.token,
      required this.salesOrder,
      required this.onTaxesChange})
      : super(key: key);
  @override
  State<DiscountsAndTaxesWidget> createState() =>
      _DiscountsAndTaxesWidgetState();
}

class _DiscountsAndTaxesWidgetState extends State<DiscountsAndTaxesWidget> {
  Future<List<BaseAPIObject>?> getTaxesDisList() async {
    return (await widget.services
            .getTaxesList(widget.branchId ?? -1, widget.token))
        .data;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnEditableData(data: appTxt(context).discountsAndTaxes),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: DropdownSearch<DocumentTaxesModel>.multiSelection(
              itemAsString: (DocumentTaxesModel model) => model.getName,
              onChanged: (List<DocumentTaxesModel> selected) {
                widget.onTaxesChange(selected);
              },
              compareFn: (selected, cur) {
                return selected.id == cur.id;
              },
              items: [
                DocumentTaxesModel(
                    valueOfTax: 14,
                    addToPrice: true,
                    fixedValue: false,
                    id: 1,
                    name: 'ضريبة القيمة المضافة'),
                DocumentTaxesModel(
                    valueOfTax: 10,
                    addToPrice: false,
                    fixedValue: false,
                    id: 2,
                    name: 'خصم مؤقت ١٠٪'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PricesAndTotals extends StatefulWidget {
  final List<DocumentTaxesModel> taxesAndDiscounts;
  const PricesAndTotals({Key? key, required this.taxesAndDiscounts})
      : super(key: key);

  @override
  State<PricesAndTotals> createState() => _PricesAndTotalsState();
}

class _PricesAndTotalsState extends State<PricesAndTotals> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Selector<EInvoiceDocProvider, double>(
        selector: (context, provider) => provider.docTotalAmount,
        builder: (_, val, __) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _numbersDataRow(appTxt(context).totalDocPriceBefore, val),
              _numbersDataRow(appTxt(context).discountOrTax,
                  calcTaxesOnly(widget.taxesAndDiscounts, val)),
              _numbersDataRow(
                  appTxt(context).totalDocPriceAfter,
                  calcTotalAfter(
                      calcTaxesOnly(widget.taxesAndDiscounts, val), val)),
            ],
          );
        },
      ),
    );
  }

  double calcTaxesOnly(List<DocumentTaxesModel> taxes, double totalAmount) {
    double val = 0;
    for (var x in taxes) {
      val += (x.addToPrice ? 1 : -1) *
          (x.fixedValue ? x.valueOfTax : (x.valueOfTax / 100) * totalAmount);
    }
    return val;
  }

  double calcTotalAfter(double taxes, double totalVal) {
    if (totalVal == 0) return 0;
    context.read<EInvoiceDocProvider>().updateTotalAfter(taxes + totalVal);
    return taxes + totalVal;
  }

  Widget _numbersDataRow(String label, double value) => Row(
        children: [
          Text(
            '$label: ',
            style: txtTheme(context)
                .titleSmall!
                .copyWith(color: appTheme(context).primaryColor),
          ),
          Text(
            value.toStringAsFixed(3),
            style: txtTheme(context)
                .titleMedium!
                .copyWith(color: appTheme(context).primaryColor, fontSize: 14),
            overflow: TextOverflow.visible,
          ),
        ],
      );
}
