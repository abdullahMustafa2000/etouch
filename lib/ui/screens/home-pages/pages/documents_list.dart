import 'package:etouch/api/api_models/login_response.dart';
import 'package:flutter/material.dart';

class EInvoicesListFragment extends StatelessWidget {
  EInvoicesListFragment({Key? key, required this.loginResponse}) : super(key: key);
  LoginResponse loginResponse;
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
