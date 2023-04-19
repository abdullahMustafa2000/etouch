import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dropdown_model.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchDropdownMenuModel extends StatefulWidget {
  SearchDropdownMenuModel(
      {Key? key,
      required this.dataList,
      required this.selectVal,
      required this.selectedItem,
      required this.hasBorders})
      : super(key: key);
  List<EInvoiceDocItemSelectionModel>? dataList;
  Function selectVal;
  EInvoiceDocItemSelectionModel? selectedItem;
  bool hasBorders;
  @override
  State<SearchDropdownMenuModel> createState() =>
      _SearchDropdownMenuModelState();
}

class _SearchDropdownMenuModelState extends State<SearchDropdownMenuModel> {
  late bool _hasBorder;
  @override
  void initState() {
    super.initState();
    _hasBorder = widget.hasBorders;
  }
  @override
  Widget build(BuildContext context) {
    return DecorateDropDown(
      dropDown: DropdownSearch<EInvoiceDocItemSelectionModel>(
        selectedItem: widget.selectedItem,
        itemAsString: (EInvoiceDocItemSelectionModel? item) => item!.getName,
        mode: Mode.MENU,
        showSelectedItems: true,
        compareFn: (EInvoiceDocItemSelectionModel? item,
            EInvoiceDocItemSelectionModel? selected) {
          return item?.getName == selected?.getName;
        },
        items: widget.dataList,
        dropdownSearchDecoration: InputDecoration(
          filled: _hasBorder,
          fillColor: appTheme(context).primaryColorDark,
          hintText: appTxt(context).searchHint,
          suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(cornersRadiusConst),
            borderSide:
                _hasBorder? BorderSide(color: appTheme(context).primaryColor, width: 1): const BorderSide(width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                _hasBorder? BorderSide(color: Theme.of(context).primaryColor, width: 1):const BorderSide(width: 0),
          ),
        ),
        onChanged: (EInvoiceDocItemSelectionModel? val) {
          widget.selectVal(val);
          setState(() {
            widget.selectedItem = val;
          });
        },
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(cornersRadiusConst),
            ),
          ),
        ),
      ),
    );
  }
}
