import 'package:etouch/ui/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Lottie.asset(noInternetPath));
  }
}
