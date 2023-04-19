import 'package:etouch/main.dart';
import 'package:etouch/ui/elements/editable_data.dart';
import 'package:etouch/ui/elements/searchable_dropdown_model.dart';
import 'package:flutter/material.dart';
import '../../businessLogic/classes/e_invoice_item_selection_model.dart';
import 'uneditable_data.dart';

class DocumentNumbers extends StatefulWidget {
  DocumentNumbers(
      {required this.taxesList,
      required this.selectedTax,
      required this.taxVal,
      required this.totalDocPrice,
      required this.addToPrice,
      required this.paymentMethods,
      required this.selectedPaymentMethod,
      required this.percentDiscountOrTax});
  List<EInvoiceDocItemSelectionModel>? taxesList, paymentMethods;
  Function selectedTax, selectedPaymentMethod;
  EInvoiceDocItemSelectionModel taxVal;
  bool addToPrice, percentDiscountOrTax;
  double totalDocPrice;
  @override
  State<DocumentNumbers> createState() => _DocumentNumbersState();
}

class _DocumentNumbersState extends State<DocumentNumbers> {
  double _amount = 0.0;

  double calcTotalAfter(double amount) {
    if (widget.addToPrice) {
      return widget.totalDocPrice + calcDiscountOrTax(amount);
    } else {
      return widget.totalDocPrice - calcDiscountOrTax(amount);
    }
  }

  double calcDiscountOrTax(double amount) {
    if (widget.percentDiscountOrTax) {
      return widget.totalDocPrice / amount;
    } else {
      return amount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DiscountsAndTaxes(
                taxesTypesList: widget.taxesList,
                selectedTax: (EInvoiceDocItemSelectionModel? val) {
                  widget.selectedTax(val);
                  setState(() {
                    _amount = val?.getId.toDouble() ?? 0.0;
                  });
                },
                taxVal: widget.taxVal,
              ),
            ),
            Expanded(
              child: PricesAndTotals(
                totalBefore: widget.totalDocPrice,
                totalAfter: _amount > 0
                    ? calcTotalAfter(_amount)
                    : widget.totalDocPrice,
                discountOrTax: _amount > 0 ? calcDiscountOrTax(_amount) : 0.0,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 24,
        ),
        CashesWidget(
          paymentMethods: widget.paymentMethods,
          selectedMethod: (EInvoiceDocItemSelectionModel? val) {
            widget.selectedPaymentMethod(val);
          },
          totalOrderPrice: widget.totalDocPrice,
        ),
      ],
    );
  }
}

class CashesWidget extends StatefulWidget {
  CashesWidget(
      {required this.paymentMethods,
      required this.selectedMethod,
      required this.totalOrderPrice});
  List<EInvoiceDocItemSelectionModel>? paymentMethods;
  Function selectedMethod;
  double totalOrderPrice;

  @override
  State<CashesWidget> createState() => _CashesWidgetState();
}

class _CashesWidgetState extends State<CashesWidget> {
  late double _restMoney;
  @override
  void initState() {
    super.initState();
    _restMoney = widget.totalOrderPrice;
  }

  void calcRestMoney(String typedAmount) {
    setState(() {
      _restMoney = widget.totalOrderPrice - double.parse(typedAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            PaidCashesWidget(
              data: appTxt(context).paymentMethods,
              content: SearchDropdownMenuModel(
                dataList: widget.paymentMethods,
                selectVal: (EInvoiceDocItemSelectionModel? val) {
                  widget.selectedMethod(val);
                },
                selectedItem: null,
                hasBorders: true,
              ),
            ),
            PaidCashesWidget(
              data: appTxt(context).paidAmount,
              content: EditableInputData(
                  data: '0.0',
                  onChange: (String? val, bool isEmpty) {
                    calcRestMoney(isEmpty ? '0.0' : val!);
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
              _restMoney.toString(),
              style: txtTheme(context)
                  .headlineLarge!
                  .copyWith(color: appTheme(context).primaryColor),
            ),
          ],
        ),
      ],
    );
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

class DiscountsAndTaxes extends StatelessWidget {
  List<EInvoiceDocItemSelectionModel>? taxesTypesList;
  Function selectedTax;
  EInvoiceDocItemSelectionModel taxVal;
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
            child: SearchDropdownMenuModel(
              dataList: taxesTypesList,
              selectVal: (EInvoiceDocItemSelectionModel? val) {
                selectedTax(val);
              },
              selectedItem: null,
              hasBorders: true,
            ),
          ),
          Text(
            taxVal.name,
            style: txtTheme(context)
                .labelSmall!
                .copyWith(color: appTheme(context).primaryColor),
          ),
        ],
      ),
    );
  }

  DiscountsAndTaxes(
      {required this.taxesTypesList,
      required this.selectedTax,
      required this.taxVal});
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
