import 'package:etouch/businessLogic/classes/inventory_item_selection_model.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dropdown_model.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchDropdownMenuModel extends StatelessWidget {
  SearchDropdownMenuModel(
      {Key? key, required this.dataList, required this.selectVal})
      : super(key: key);
  List<InventoryItemSelectionModel> dataList;
  Function selectVal;
  @override
  Widget build(BuildContext context) {
    return DecorateDropDown(
      dropDown: DropdownSearch<InventoryItemSelectionModel>(
        itemAsString: (InventoryItemSelectionModel? item) => item!.getName,
        mode: Mode.MENU,
        showSelectedItems: true,
        compareFn: (InventoryItemSelectionModel? item,
            InventoryItemSelectionModel? selected) {
          return item?.getName == selected?.getName;
        },
        items: dataList,
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
        onChanged: (InventoryItemSelectionModel? val) {
          selectVal(val);
        },
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          cursorColor: Theme.of(context).primaryColor,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(cornersRadiusConst))),
        ),
      ),
    );
  }
}
