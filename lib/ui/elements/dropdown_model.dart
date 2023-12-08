import 'package:etouch/businessLogic/classes/base_api_response.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class DropDownMenuModel extends StatefulWidget {
  DropDownMenuModel(
      {Key? key,
      required this.dataList,
      required this.defValue,
      required this.selectedVal})
      : super(key: key);
  final List<BaseAPIObject>? dataList;
  BaseAPIObject? defValue;
  final Function selectedVal;
  @override
  State<DropDownMenuModel> createState() => _DropDownMenuModelState();
}

class _DropDownMenuModelState extends State<DropDownMenuModel> {
  @override
  Widget build(BuildContext context) {
    return DecorateDropDown(
      dropDown: DropdownButtonHideUnderline(
        child: DropdownButton<BaseAPIObject>(
          value: widget.dataList?.firstWhere(
              (element) => widget.defValue?.getId == element.getId),
          onChanged: (BaseAPIObject? value) {
            setState(
              () {
                widget.defValue = value ?? widget.dataList?.first;
                widget.selectedVal(value);
              },
            );
          },
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.black),
          items: (widget.dataList ?? []).map<DropdownMenuItem<BaseAPIObject>>(
            (BaseAPIObject item) {
              return DropdownMenuItem<BaseAPIObject>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    item.getName,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: switchThumbColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ).toList(),
          icon: Icon(
            Icons.keyboard_arrow_down_sharp,
            color: darkGrayColor,
          ),
          isExpanded: true,
        ),
      ),
    );
  }
}

class DecorateDropDown extends StatelessWidget {
  DecorateDropDown({Key? key, required this.dropDown}) : super(key: key);
  Widget dropDown;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cornersRadiusConst),
          color: Colors.white),
      child: dropDown,
    );
  }
}
