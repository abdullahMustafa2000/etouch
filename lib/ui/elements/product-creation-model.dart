import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dropdown-search-model.dart';
import 'package:flutter/material.dart';

class ProductCreationModel extends StatelessWidget {
  const ProductCreationModel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(cornersRadiusConst)),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      child: Center(
        child: DataTypeRow(
          child: SearchDropdownMenuModel(dataList: const ['AB', 'CD', 'EF'],),
          label: '',
        ),
      ),
    );
  }
}

class DataTypeRow extends StatelessWidget {
  DataTypeRow({Key? key, required this.child, required this.label})
      : super(key: key);
  Widget child;
  String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).primaryColor),
        ),
        child,
      ],
    );
  }
}
