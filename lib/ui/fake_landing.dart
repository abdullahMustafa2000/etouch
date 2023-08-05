// ignore_for_file: must_be_immutable
import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/ui/screens/home_screen.dart';
import 'package:etouch/ui/screens/preview_doc.dart';
import 'package:flutter/material.dart';

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
      body: Container()
    );
  }
}

/*
HomePageScreen(
          loginResponse: LoginResponse(
              token: 'token',
              expiration: DateTime.now(),
              userRules: [],
              foundationId: 1,
              companyId: 1,
              userBranches: []),
        )
 */
