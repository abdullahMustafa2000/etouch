import 'package:dropdown_search/dropdown_search.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/elements/editable_data.dart';
import 'package:etouch/ui/elements/searchable_dropdown_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../api/api_models/tax_of_document_model.dart';
import '../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../elements/uneditable_data.dart';

class DocumentNumbers extends StatefulWidget {
  final String token;
  final MyApiServices services;
  const DocumentNumbers({Key? key, required this.services, required this.token})
      : super(key: key);
  @override
  State<DocumentNumbers> createState() => _DocumentNumbersState();
}

class _DocumentNumbersState extends State<DocumentNumbers> {
  double _amount = 0.0;
  DocumentTaxesModel? _selectedTax;
  late EInvoiceDocProvider _docProvider;
  @override
  void initState() {
    super.initState();
  }

  double calcTotalAfter(double amount) {
    if (_selectedTax == null) return 0.0;
    if (_selectedTax!.addToPrice) {
      return _docProvider.salesOrder.totalOrderAmount +
          calcDiscountOrTax(amount);
    } else {
      return _docProvider.salesOrder.totalOrderAmount -
          calcDiscountOrTax(amount);
    }
  }

  double calcDiscountOrTax(double amount) {
    if (!_selectedTax!.fixedValue) {
      return _docProvider.salesOrder.totalOrderAmount / amount;
    } else {
      return amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    _docProvider = Provider.of<EInvoiceDocProvider>(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DiscountsAndTaxes(
                services: widget.services,
                branchId: _docProvider.salesOrder.branchId,
                token: widget.token,
              ),
            ),
            Expanded(
              child: PricesAndTotals(
                totalBefore: _docProvider.salesOrder.totalOrderAmount,
                totalAfter: _amount > 0
                    ? calcTotalAfter(_amount)
                    : _docProvider.salesOrder.totalOrderAmount,
                discountOrTax: _amount > 0 ? calcDiscountOrTax(_amount) : 0.0,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        CashesWidget(
          services: widget.services,
          branchId: _docProvider.salesOrder.branchId,
          token: widget.token,
        ),
      ],
    );
  }
}

class CashesWidget extends StatefulWidget {
  const CashesWidget(
      {Key? key, required this.services, this.branchId, this.token})
      : super(key: key);
  final MyApiServices services;
  final int? branchId;
  final String? token;

  @override
  State<CashesWidget> createState() => _CashesWidgetState();
}

class _CashesWidgetState extends State<CashesWidget> {
  late EInvoiceDocProvider _docProvider;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _docProvider = Provider.of<EInvoiceDocProvider>(context);
    return Column(
      children: [
        Row(
          children: [
            PaidCashesWidget(
              data: appTxt(context).paymentMethods,
              content: SearchDropdownMenuModel(
                dataList: _docProvider.companyPaymentMethods,
                onItemSelected: (BaseAPIObject? val) {
                  if (val != null) {
                    _docProvider.salesOrder.paymentMethods[0] = val;
                  }
                },
                selectedItem: firstOrNull(
                    _docProvider.salesOrder.paymentMethods.isNotEmpty
                        ? _docProvider.salesOrder.paymentMethods.first.getId
                        : null),
              ),
            ),
            PaidCashesWidget(
              data: appTxt(context).paidAmount,
              content: EditableInputData(
                  data: '0.0',
                  onChange: (String? val, bool isEmpty) {
                    _docProvider
                        .updatePaidAmount(isEmpty ? 0 : double.parse(val!));
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
              (_docProvider.salesOrder.totalOrderAmount -
                      _docProvider.salesOrder.paid)
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

  BaseAPIObject? firstOrNull(int? id) {
    if (id == null) return null;
    _docProvider.companyPaymentMethods
        ?.firstWhere((element) => (element.getId) == id);
  }
}

class PaidCashesWidget extends StatelessWidget {
  PaidCashesWidget({Key? key, required this.data, required this.content})
      : super(key: key);
  String data;
  Widget content;
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

class DiscountsAndTaxes extends StatefulWidget {
  final MyApiServices services;
  final int? branchId;
  final String token;
  const DiscountsAndTaxes(
      {Key? key,
      required this.services,
      required this.branchId,
      required this.token})
      : super(key: key);
  @override
  State<DiscountsAndTaxes> createState() => _DiscountsAndTaxesState();
}

class _DiscountsAndTaxesState extends State<DiscountsAndTaxes> {
  late Future<List<BaseAPIObject>?> _disAndTax;
  late EInvoiceDocProvider _docProvider;
  Future<List<BaseAPIObject>?> getTaxesDisList() async {
    return (await widget.services
            .getTaxesList(widget.branchId ?? -1, widget.token))
        .data;
  }

  @override
  void initState() {
    _disAndTax = getTaxesDisList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _docProvider = Provider.of<EInvoiceDocProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UnEditableData(data: appTxt(context).discountsAndTaxes),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: FutureBuilder<List<BaseAPIObject>?>(
              future: _disAndTax,
              builder: (context, AsyncSnapshot<List<BaseAPIObject>?> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snap.hasData) {
                    return DropdownSearch<BaseAPIObject>.multiSelection(
                      clearButtonProps: const ClearButtonProps(isVisible: true),
                      onChanged: (List<BaseAPIObject> selected) {
                        _docProvider.salesOrder.taxesAndDiscounts = selected;
                      },
                      items: snap.data ?? [],
                    );
                  } else {
                    return Center(
                      child: Text(appTxt(context).emptyDataError),
                    );
                  }
                }
              },
            ),
          ),
          // Text(
          //   taxVal?.name ?? '',
          //   style: txtTheme(context)
          //       .labelSmall!
          //       .copyWith(color: appTheme(context).primaryColor),
          // ),
        ],
      ),
    );
  }
}

class PricesAndTotals extends StatelessWidget {
  double totalBefore, discountOrTax, totalAfter;
  PricesAndTotals(
      {required this.totalBefore,
      required this.discountOrTax,
      required this.totalAfter});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NumbersDataRow(
              title: appTxt(context).totalDocPriceBefore, number: totalBefore),
          NumbersDataRow(
              title: appTxt(context).discountOrTax, number: discountOrTax),
          NumbersDataRow(
              title: appTxt(context).totalDocPriceAfter, number: totalAfter),
        ],
      ),
    );
  }
}

class NumbersDataRow extends StatelessWidget {
  String title;
  double number;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$title: ',
          style: txtTheme(context)
              .titleSmall!
              .copyWith(color: appTheme(context).primaryColor),
        ),
        Text(
          number.toStringAsFixed(3),
          style: txtTheme(context)
              .titleMedium!
              .copyWith(color: appTheme(context).primaryColor, fontSize: 14),
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }

  NumbersDataRow({required this.title, required this.number});
}
