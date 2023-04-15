import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/searchable_dropdown_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../businessLogic/classes/e_invoice_item_selection_model.dart';
import 'editable_data.dart';
import 'primary_btn_model.dart';
import 'uneditable_data.dart';

class ProductCreationModel extends StatefulWidget {
  ProductCreationModel(
      {Key? key,
      required this.groupsList,
      required this.productsList,
      required this.unitsList,
      required this.balance,
      required this.productPrice,
      required this.isPriceEditable,
      required this.hasGroups,
      required this.selectedGroup,
      required this.selectedProduct,
      required this.selectedUnit,
      required this.selectedQuantity,
      required this.selectedPrice,
      required this.onDeleteItemClicked,
      required this.moreThanOneItem,})
      : super(key: key);
  int balance;
  bool isPriceEditable, hasGroups, moreThanOneItem;
  double productPrice;
  List<EInvoiceDocItemSelectionModel>? groupsList, productsList, unitsList;
  Function selectedGroup,
      selectedProduct,
      selectedUnit,
      selectedQuantity,
      selectedPrice,
      onDeleteItemClicked;

  @override
  State<ProductCreationModel> createState() => _ProductCreationModelState();
}

class _ProductCreationModelState extends State<ProductCreationModel> {
  double _totalPrice = 0.0, _prodPrice = 0.0;
  int _quantity = 0;
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _prodPrice = widget.productPrice;
  }
  void updateTotalPrice(int quantity, double price) {
    setState(() {
      _totalPrice = quantity * price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(cornersRadiusConst)),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Scrollbar(
          thumbVisibility: true,
          controller: _controller,
          child: ListView(
            controller: _controller,
            children: [
              Visibility(
                visible: widget.hasGroups,
                child: InputTypeRow(
                  label: appTxt(context).groupOfInventory,
                  child: SearchDropdownMenuModel(
                    dataList: widget.groupsList,
                    selectVal: (EInvoiceDocItemSelectionModel? val) {
                      widget.selectedGroup(val);
                    },
                  ),
                ),
              ),
              InputTypeRow(
                label: appTxt(context).productsOfInventory,
                child: SearchDropdownMenuModel(
                  dataList: widget.productsList,
                  selectVal: (EInvoiceDocItemSelectionModel? val) {
                    widget.selectedProduct(val);
                  },
                ),
              ),
              InputTypeRow(
                label: appTxt(context).balanceOfInventory,
                child: UnEditableData(
                  data: widget.balance.toDouble().toString(),
                ),
              ),
              InputTypeRow(
                label: appTxt(context).quantityOfInventory,
                child: EditableInputData(
                    data: 0,
                    hasInitValue: false,
                    onChange: (String? val, bool isEmpty) {
                      widget.selectedQuantity(val);
                      _quantity = !isEmpty ? int.parse(val!) : 0;
                      updateTotalPrice(_quantity, _prodPrice);
                    }),
              ),
              InputTypeRow(
                label: appTxt(context).unitOfInventory,
                child: SearchDropdownMenuModel(
                  dataList: widget.unitsList,
                  selectVal: (EInvoiceDocItemSelectionModel? val) {
                    widget.selectedUnit(val);
                  },
                ),
              ),
              InputTypeRow(
                label: appTxt(context).priceOfInventory,
                child: widget.isPriceEditable
                    ? EditableInputData(
                        data: widget.productPrice,
                        hasInitValue: true,
                        onChange: (String? val, bool isEmpty) {
                          _prodPrice = double.parse(val!);
                          widget.selectedPrice(val);
                          updateTotalPrice(
                              _quantity, !isEmpty ? _prodPrice : 0.0);
                        })
                    : UnEditableData(data: widget.productPrice.toString()),
              ),
              Column(
                children: [
                  Text(
                    appTxt(context).totalTxt,
                    style: txtTheme(context)
                        .displaySmall!
                        .copyWith(color: appTheme(context).primaryColor),
                  ),
                  Text(
                    _totalPrice.toString(),
                    style: txtTheme(context)
                        .displayLarge!
                        .copyWith(color: appTheme(context).primaryColor),
                  ),
                  const SizedBox(height: 18,),
                  Visibility(
                    visible: widget.moreThanOneItem,
                    child: PrimaryClrBtnModel(
                      content: Text(
                        appTxt(context).removeProductFromDocument,
                        style: txtTheme(context).labelLarge!.copyWith(color: pureWhite),
                      ),
                      color: closeColor,
                      onPressed: () {
                        widget.onDeleteItemClicked();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InputTypeRow extends StatelessWidget {
  InputTypeRow({Key? key, required this.child, required this.label})
      : super(key: key);
  Widget child;
  String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 14),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}