
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

class EditableInputData extends StatefulWidget {
  EditableInputData(
      {Key? key,
        required this.data,
        required this.onChange,
        required this.hasInitValue})
      : super(key: key);
  String data;
  Function onChange;
  bool hasInitValue;
  @override
  State<EditableInputData> createState() => _EditableInputDataState();
}

class _EditableInputDataState extends State<EditableInputData> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.hasInitValue) {
      setState(() {
        _controller.text = widget.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (txt) {
        widget.onChange(txt, _controller.text.isEmpty);
      },
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: InputDecoration(
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
      ),
    );
  }
}
