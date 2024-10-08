import 'package:flutter/material.dart';

class PrimaryClrBtnModel extends StatelessWidget {
  PrimaryClrBtnModel({required this.content, required this.onPressed, required this.color});
  Function onPressed;
  Widget content;
  Color color;
  //double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //width: width,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll<Color>(color),
        ),
        child: content,
      ),
    );
  }

}
