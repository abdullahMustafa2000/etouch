import 'package:flutter/material.dart';

class EReceiptDashboard extends StatelessWidget {
  const EReceiptDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Hello from E-Receipt',
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
