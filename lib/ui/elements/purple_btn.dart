import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

class PurpleButtonModel extends StatelessWidget {
  Function onTap;
  Widget content;
  double width;
  PurpleButtonModel({required this.content, required this.onTap, required this.width});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [primaryColor, accentColor],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter),
          borderRadius:
              const BorderRadius.all(Radius.circular(cornersRadiusConst)),
        ),
        child: Center(child: content),
      ),
    );
  }
}
