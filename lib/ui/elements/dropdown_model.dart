import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';
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
  List<BaseAPIObject>? dataList;
  BaseAPIObject? defValue;
  Function selectedVal;
  @override
  State<DropDownMenuModel> createState() => _DropDownMenuModelState(defValue);
}

class _DropDownMenuModelState extends State<DropDownMenuModel> {
  BaseAPIObject? curValue;
  late List<BaseAPIObject>? mList;
  _DropDownMenuModelState(this.curValue);
  @override
  void initState() {
    mList = widget.dataList;
    curValue = widget.defValue;
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant DropDownMenuModel oldWidget) {
  //   setState(() {
  //     curValue = curValue ??
  //         (widget.dataList != null && widget.dataList!.isNotEmpty
  //             ? widget.dataList!.first
  //             : null);
  //   });
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return DecorateDropDown(
      dropDown: DropdownButtonHideUnderline(
        child: DropdownButton<BaseAPIObject>(
          value: curValue,
          onChanged: (BaseAPIObject? value) {
            setState(
              () {
                curValue = value ?? mList?.first;
                widget.selectedVal(value);
              },
            );
          },
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.black),
          items: (mList ?? []).map<DropdownMenuItem<BaseAPIObject>>(
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
