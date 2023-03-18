import 'package:flutter/material.dart';

class PrimaryClrBtn extends StatelessWidget {
  PrimaryClrBtn({required this.content, required this.onPressed});
  Function onPressed;
  Widget content;
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
              MaterialStatePropertyAll<Color>(Theme.of(context).primaryColor),
        ),
        child: content,
      ),
    );
  }

}
