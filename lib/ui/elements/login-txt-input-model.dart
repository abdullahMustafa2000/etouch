import 'package:flutter/material.dart';
import 'package:etouch/ui/constants.dart';

class LoginTextFieldModel extends StatefulWidget {
  LoginTextFieldModel(
      {required this.hint,
      required this.isPassword,
      required this.onTxtChanged});
  String hint;
  bool isPassword;
  Function onTxtChanged;
  @override
  State<LoginTextFieldModel> createState() => _LoginTextFieldModelState();
}

class _LoginTextFieldModelState extends State<LoginTextFieldModel> {
  bool passwordInvisible = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (txt) {
        widget.onTxtChanged(txt);
      },
      style: Theme.of(context).textTheme.headlineSmall,
      obscureText: widget.isPassword && passwordInvisible,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(cornersRadiusConst)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        hintText: widget.hint,
        prefixIcon: IconButton(
          onPressed: () {},
          icon: widget.isPassword
              ? const Icon(
                  Icons.lock, size: 16,
                )
              : const Icon(
                  Icons.account_circle_outlined, size: 16,
                ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  passwordInvisible = !passwordInvisible;
                  setState(() {});
                },
                icon: passwordInvisible
                    ? const Icon(Icons.visibility, size: 16,)
                    : const Icon(Icons.visibility_off, size: 16,))
            : const Icon(
                Icons.visibility_off,
                color: Colors.transparent,
              ),
      ),
    );
  }
}
