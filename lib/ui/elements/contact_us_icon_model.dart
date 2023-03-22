import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

class ContactUsIconModel extends StatelessWidget {
  ContactUsIconModel({required this.icon, required this.onIconClicked});
  String icon;
  Function onIconClicked;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onIconClicked();
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 1),
          borderRadius:
              const BorderRadius.all(Radius.circular(cornersRadiusConst)),
        ),
        child: SizedBox(
          child: Center(
            child: Image.asset(
              icon,
              width: 19,
              height: 19,
              color: icon==logo?Theme.of(context).primaryColor:null,
            ),
          ),
        ),
      ),
    );
  }
}
