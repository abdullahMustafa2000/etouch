import 'package:etouch/api/api_models/login_response.dart';
import 'package:flutter/material.dart';

class EInvoicesListFragment extends StatelessWidget {
  EInvoicesListFragment({Key? key, required this.loginResponse}) : super(key: key);
  LoginResponse loginResponse;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          //title
          //list of search options
          //search btn
        ],
      ),
    );
  }
}
