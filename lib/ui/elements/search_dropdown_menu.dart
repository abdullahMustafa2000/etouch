import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchDropdownMenuModel extends StatelessWidget {
  SearchDropdownMenuModel({Key? key, required this.dataList}) : super(key: key);
  List<String> dataList;
  @override
  Widget build(BuildContext context) {
    return DecorateDropDown(
      dropDown: DropdownSearch<String>(
        mode: Mode.MENU,
        showSelectedItems: true,
        items: dataList,
        dropdownSearchDecoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchHint,
          suffixIcon: const Icon(Icons.keyboard_arrow_down_sharp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(cornersRadiusConst),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        onChanged: (String? val) {},
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
