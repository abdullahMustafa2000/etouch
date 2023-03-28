import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateDocumentScreen extends StatelessWidget {
  const CreateDocumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Hello from E-Invoice order Create',
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
