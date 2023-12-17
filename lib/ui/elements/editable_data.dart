import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class EditableInputData extends StatefulWidget {
  const EditableInputData(
      {Key? key,
        this.inputHint,
      required this.data,
      required this.onChange,
      required this.hasInitValue,
      this.errorMessage})
      : super(key: key);
  final String? data;
  final Function onChange;
  final bool hasInitValue;
  final String? inputHint;
  final String? errorMessage;

  @override
  State<EditableInputData> createState() => _EditableInputDataState();
}

class _EditableInputDataState extends State<EditableInputData> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      _controller.text = widget.data ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (txt) {
        widget.onChange(txt, _controller.text.isEmpty);
      },
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: _formatter(),
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: _decoration(hint: widget.inputHint, errMessage: widget.errorMessage),
    );
  }

  List<TextInputFormatter> _formatter() {
    return <TextInputFormatter>[
      //FilteringTextInputFormatter.digitsOnly,
      FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
      TextInputFormatter.withFunction((oldValue, newValue) {
        final text = newValue.text;
        return text.isEmpty
            ? newValue
            : double.tryParse(text) == null
                ? oldValue
                : newValue;
      })
    ];
  }

  InputDecoration _decoration({String? hint, String? errMessage}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(cornersRadiusConst)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
      ),
      hintText: hint,
      errorText: errMessage,
    );
  }
}
