import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dropdown-search-model.dart';
import 'package:etouch/ui/elements/login-txt-input-model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../businessLogic/classes/inventory_item_selection_model.dart';

class ProductCreationModel extends StatelessWidget {
  ProductCreationModel(
      {Key? key,
      required this.groupsList,
      required this.productsList,
      required this.unitsList,
      required this.balance,
      required this.price,
      required this.isPriceEditable,
      required this.selectedGroup,
      required this.selectedProduct,
      required this.selectedUnit,
      required this.selectedQuantity,
      required this.selectedPrice})
      : super(key: key);
  int balance;
  double price;
  bool isPriceEditable;
  List<InventoryItemSelectionModel> groupsList, productsList, unitsList;
  Function selectedGroup,
      selectedProduct,
      selectedUnit,
      selectedQuantity,
      selectedPrice;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(cornersRadiusConst)),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InputTypeRow(
              label: appTxt(context).groupOfInventory,
              child: SearchDropdownMenuModel(
                dataList: groupsList,
                selectVal: (InventoryItemSelectionModel? val) {
                  selectedGroup(val);
                },
              ),
            ),
            InputTypeRow(
              label: appTxt(context).productsOfInventory,
              child: SearchDropdownMenuModel(
                dataList: productsList,
                selectVal: (InventoryItemSelectionModel? val) {
                  selectedProduct(val);
                },
              ),
            ),
            InputTypeRow(
              label: appTxt(context).balanceOfInventory,
              child: UnEditableData(
                data: balance.toDouble(),
              ),
            ),
            InputTypeRow(
              label: appTxt(context).quantityOfInventory,
              child: EditableInputData(
                  data: 0,
                  onChange: (String? val) {
                    selectedQuantity(val);
                  }),
            ),
            InputTypeRow(
              label: appTxt(context).unitOfInventory,
              child: SearchDropdownMenuModel(
                dataList: unitsList,
                selectVal: (InventoryItemSelectionModel? val) {
                  selectedUnit(val);
                },
              ),
            ),
            InputTypeRow(
              label: appTxt(context).priceOfInventory,
              child: isPriceEditable
                  ? EditableInputData(
                      data: price,
                      onChange: (String? val) {
                        selectedPrice(val);
                      })
                  : UnEditableData(data: price),
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
                  '16200',
                  style: txtTheme(context)
                      .displayLarge!
                      .copyWith(color: appTheme(context).primaryColor),
                ),
              ],
            )
          ],
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

class UnEditableData extends StatelessWidget {
  UnEditableData({Key? key, required this.data}) : super(key: key);
  double data;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(cornersRadiusConst)),
        color: lighterSecondaryClr,
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: Text(
          data.toString(),
          style: txtTheme(context)
              .titleMedium!
              .copyWith(color: primaryColor, fontSize: 14),
        ),
      ),
    );
  }
}

class EditableInputData extends StatefulWidget {
  EditableInputData({Key? key, required this.data, required this.onChange})
      : super(key: key);
  double data;
  Function onChange;

  @override
  State<EditableInputData> createState() => _EditableInputDataState();
}

class _EditableInputDataState extends State<EditableInputData> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = widget.data.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (txt) {
        widget.onChange(txt);
      },
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cornersRadiusConst)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
