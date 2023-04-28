// ignore_for_file: must_be_immutable
import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'elements/document_for_listing_model.dart';

class FakeLanding extends StatefulWidget {
  @override
  State<FakeLanding> createState() => _FakeLandingState();
}

class _FakeLandingState extends State<FakeLanding>
    with TickerProviderStateMixin {
  PageController controller = PageController();
  late AnimationController animController;
  @override
  void initState() {
    super.initState();
    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _playAnim();
  }

  Future<void> _playAnim() async {
    try {
      await animController.forward().orCancel;
    } on TickerCanceled {
      // something happened
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
      child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DocumentForListingWidget(
                  cardTitle: 'asdffa',
                  registrationId: 1.toString(),
                  customerName: 'degla',
                  submissionDate: DateTime.now().toString(),
                  totalAmount: 1200.toString(),
                  status: 'valid'),
              DocumentForListingWidget(
                  cardTitle: 'asdffa',
                  registrationId: 1.toString(),
                  customerName: 'degla',
                  submissionDate: DateTime.now().toString(),
                  totalAmount: 1200.toString(),
                  status: 'invalid'),
              DocumentForListingWidget(
                  cardTitle: 'asdffa',
                  registrationId: 1.toString(),
                  customerName: 'degla',
                  submissionDate: DateTime.now().toString(),
                  totalAmount: 1200.toString(),
                  status: 'rejected'),
              DocumentForListingWidget(
                  cardTitle: 'asdffa',
                  registrationId: 1.toString(),
                  customerName: 'degla',
                  submissionDate: DateTime.now().toString(),
                  totalAmount: 1200.toString(),
                  status: 'cancelled'),
            ],
      )
    ),
          ),
        ));
  }
}
