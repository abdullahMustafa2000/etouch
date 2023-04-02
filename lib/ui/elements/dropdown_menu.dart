import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class DropDownMenuModel extends StatefulWidget {
  DropDownMenuModel({Key? key, required this.dataList, required this.defValue})
      : super(key: key);
  List<String> dataList;
  String defValue;
  @override
  State<DropDownMenuModel> createState() => _DropDownMenuModelState();
}

class _DropDownMenuModelState extends State<DropDownMenuModel> {
  late String _dropDownValue;

  @override
  void initState() {
    super.initState();
    _dropDownValue = widget.defValue;
  }

  @override
  Widget build(BuildContext context) {
    return DecorateDropDown(
      dropDown: DropdownButtonHideUnderline(
        child: DropdownButton2(
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.black),
          items: widget.dataList.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(color: switchThumbColor),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value is String) {
              setState(() {
                _dropDownValue = value;
              });
            }
          },
          iconStyleData: IconStyleData(
            icon: Icon(
              Icons.keyboard_arrow_down_sharp,
              color: darkGrayColor,
            ),
          ),
          value: _dropDownValue,
          isExpanded: true,
        ),
      ),
    );
  }
}

class DecorateDropDown extends StatelessWidget {
  DecorateDropDown({required this.dropDown});
  Widget dropDown;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cornersRadiusConst),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: DropdownButtonHideUnderline(
          child: dropDown,
        ),
      ),
    );
  }
}

/*
dataList.map<DropdownMenuItem<String>>((String item) {
        return const DropdownMenuItem(
          value: "S",
          child: Text("T"),
        );
      }).toList()
 */
