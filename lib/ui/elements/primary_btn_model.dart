import 'package:flutter/material.dart';

class PrimaryClrBtn extends StatelessWidget {
  PrimaryClrBtn(this.btnInnerTxt, this.icon, this.onPressed);
  String? btnInnerTxt;
  String? icon;
  Function onPressed;
  //double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: width,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor),
        ),
        child: btnInnerTxt != null
            ? Text(
                btnInnerTxt!,
                style: TextStyle(color: Theme.of(context).primaryColorDark),
              )
            : Image.asset(icon!),
      ),
    );
  }

}
