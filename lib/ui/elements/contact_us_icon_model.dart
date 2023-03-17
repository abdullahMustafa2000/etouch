import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

class ContactUsIconModel extends StatelessWidget {
  ContactUsIconModel(this.icon);
  var icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(cornersRadiusConst)),
      ),
      child: SizedBox(
        child: Center(
          child: Image.asset(icon, width: 19, height: 19,),
        ),
      ),
    );
  }
}