import 'package:flutter/material.dart';

import '../../main.dart';
import '../constants.dart';
import '../themes/themes.dart';

class UnEditableData extends StatelessWidget {
  UnEditableData({Key? key, required this.data}) : super(key: key);
  String data;
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
          data,
          style: txtTheme(context)
              .titleMedium!
              .copyWith(color: primaryColor, fontSize: 14),
        ),
      ),
    );
  }
}