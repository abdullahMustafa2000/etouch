import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/searchable_dropdown_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import '../../api/api_models/product_content.dart';
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
      required this.selectedGroupFun,
      required this.selectedProductFun,
      required this.selectedUnitFun,
      required this.selectedQuantityFun,
      required this.selectedPriceFun,
      required this.onDeleteItemClickedFun,
      required this.moreThanOneItem,
      required this.selectedGroupVal,
      required this.selectedProductVal,
      required this.selectedUnitVal,
      required this.selectedQuantityVal,
      required this.totalProductPrice})
      : super(key: key);
  int balance, selectedQuantityVal;
  bool isPriceEditable, moreThanOneItem;
  double productPrice;
  List<BaseAPIObject>? groupsList, unitsList;
  List<ProductModel>? productsList;
  Function selectedGroupFun,
      selectedProductFun,
      selectedUnitFun,
      selectedQuantityFun,
      selectedPriceFun,
      onDeleteItemClickedFun,
      totalProductPrice;
  BaseAPIObject? selectedGroupVal, selectedProductVal, selectedUnitVal;
  @override
  State<ProductCreationModel> createState() => _ProductCreationModelState();
}

class _ProductCreationModelState extends State<ProductCreationModel> {
  double _totalPrice = 0.0, _prodPrice = 0.0;
  int _quantity = 0;
  BaseAPIObject? _selectedGroupVal, _selectedProductVal, _selectedUnitVal;
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _prodPrice = widget.productPrice;
    _selectedGroupVal = widget.selectedGroupVal;
    _selectedProductVal = widget.selectedProductVal;
    _selectedUnitVal = widget.selectedUnitVal;
    _quantity = widget.selectedQuantityVal;
  }

  void updateTotalPrice(int quantity, double price) {
    setState(() {
      _totalPrice = quantity * price;
    });
    widget.totalProductPrice(_totalPrice);
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
              InputTypeRow(
                label: appTxt(context).groupOfInventory,
                child: SearchDropdownMenuModel(
                  dataList: widget.groupsList,
                  onItemSelected: (BaseAPIObject? val) {
                    widget.selectedGroupFun(val);
                  },
                  selectedItem: _selectedGroupVal,
                ),
              ),
              InputTypeRow(
                label: appTxt(context).productsOfInventory,
                child: SearchDropdownMenuModel(
                  dataList: widget.productsList
                      ?.map((e) => BaseAPIObject(
                          id: e.productId ?? 0, name: e.productName ?? ''))
                      .toList(),
                  onItemSelected: (BaseAPIObject? val) {
                    widget.selectedProductFun(val);
                  },
                  selectedItem: _selectedProductVal,
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
                    data: _quantity.toString(),
                    hasInitValue: true,
                    onChange: (String? val, bool isEmpty) {
                      widget.selectedQuantityFun(isEmpty ? '0' : val);
                      _quantity = !isEmpty ? int.parse(val!) : 0;
                      updateTotalPrice(_quantity, _prodPrice);
                    }),
              ),
              InputTypeRow(
                label: appTxt(context).unitOfInventory,
                child: SearchDropdownMenuModel(
                  dataList: widget.unitsList,
                  onItemSelected: (BaseAPIObject? val) {
                    widget.selectedUnitFun(val);
                  },
                  selectedItem: _selectedUnitVal,
                ),
              ),
              InputTypeRow(
                label: appTxt(context).priceOfInventory,
                child: widget.isPriceEditable
                    ? EditableInputData(
                        data: widget.productPrice.toString(),
                        hasInitValue: true,
                        onChange: (String? val, bool isEmpty) {
                          _prodPrice = double.parse(isEmpty ? '0.0' : val!);
                          widget.selectedPriceFun(isEmpty ? '0' : val);
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
                  const SizedBox(
                    height: 18,
                  ),
                  Visibility(
                    visible: widget.moreThanOneItem,
                    child: PrimaryClrBtnModel(
                      content: Text(
                        appTxt(context).removeProductFromDocument,
                        style: txtTheme(context)
                            .labelLarge!
                            .copyWith(color: pureWhite),
                      ),
                      color: closeColor,
                      onPressed: () {
                        widget.onDeleteItemClickedFun();
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
