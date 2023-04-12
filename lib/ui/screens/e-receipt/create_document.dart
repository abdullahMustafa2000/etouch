import 'package:flutter/material.dart';

class CreateEReceiptDocumentScreen extends StatelessWidget {
  const CreateEReceiptDocumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          'Welcome to CreateEReceiptScreen',
          style: Theme.of(context)
              .textTheme
              .displayLarge!
              .copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
