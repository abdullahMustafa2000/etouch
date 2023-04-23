import 'package:flutter/material.dart';

class EInvoicesListFragment extends StatelessWidget {
  const EInvoicesListFragment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Hello from E-Invoice Listing',
        style: Theme.of(context)
            .textTheme
            .displayLarge!
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
