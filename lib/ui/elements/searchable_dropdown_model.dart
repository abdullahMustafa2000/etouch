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
      required this.onItemSelected,
      required this.selectedItem})
      : super(key: key);
  final List<BaseAPIObject>? dataList;
  final Function onItemSelected;
  BaseAPIObject? selectedItem;
  @override
  State<SearchDropdownMenuModel> createState() =>
      _SearchDropdownMenuModelState();
}

class _SearchDropdownMenuModelState extends State<SearchDropdownMenuModel> {
  @override
  Widget build(BuildContext context) {
    return DecorateDropDown(
      dropDown: DropdownSearch<BaseAPIObject>(
        selectedItem: widget.selectedItem,
        itemAsString: (BaseAPIObject? item) => item!.getName,
        compareFn: (BaseAPIObject? item, BaseAPIObject? selected) {
          return item?.getName == selected?.getName;
        },
        items: widget.dataList ?? [],
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            filled: true,
            fillColor: appTheme(context).primaryColorDark,
            hintText: appTxt(context).searchHint,
            suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(cornersRadiusConst),
              borderSide:
                  BorderSide(color: appTheme(context).primaryColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1),
            ),
          ),
        ),
        onChanged: (BaseAPIObject? val) {
          widget.onItemSelected(val);
          setState(() {
            widget.selectedItem = val;
          });
        },
        popupProps: PopupProps.menu(
          searchDelay: const Duration(microseconds: 500),
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
      ),
    );
  }
}
