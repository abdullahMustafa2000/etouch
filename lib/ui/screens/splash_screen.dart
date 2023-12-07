import 'dart:async';
import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/businessLogic/shared_preferences/user_info_saver.dart';
import 'package:etouch/ui/screens/home_screen.dart';
import 'package:etouch/ui/screens/login_screen.dart';
import 'package:etouch/ui/screens/orientation/orientation_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController logoController, appNameController;
  late Animation<double> opacityAnim, appNameOpacityAnim;
  late Animation<double> scaleAnim;
  late Animation<double> positionAnim;
  late Animation<EdgeInsets> padding;
  late Animation<BorderRadius> borderRadius;
  late Animation<Color> color;
  late SharedPreferences preferences;
  UserInfoPreferences userInfoPreferences = UserInfoPreferences();
  late Future<LoginResponse> _loginResponseFuture;
  Future<LoginResponse> getUserInfo() async {
    preferences = await SharedPreferences.getInstance();
    return await userInfoPreferences.retrieveUserInfo();
  }

  @override
  void initState() {
    _loginResponseFuture = getUserInfo();
    super.initState();
    logoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    appNameController = AnimationController(
      value: 0,
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    scaleAnim = Tween<double>(begin: 2, end: 1).animate(CurvedAnimation(
        parent: logoController,
        curve: const Interval(0, 0.5, curve: Curves.linear)));
    opacityAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: logoController,
        curve: const Interval(0, 1, curve: Curves.linear)));
    positionAnim = Tween<double>(begin: 0, end: -33).animate(CurvedAnimation(
        parent: appNameController,
        curve: const Interval(0, 1, curve: Curves.linear)));
    appNameOpacityAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: appNameController,
            curve: const Interval(0, 1, curve: Curves.linear)));
    logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) appNameController.forward();
    });
    Timer(
      const Duration(milliseconds: 2100),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          if ((preferences.getBool('FirstOpen') == null ||
              preferences.getBool('FirstOpen')!)) {
            preferences.setBool('FirstOpen', false);
            return OrientaionScreen();
          } else {
            return FutureBuilder<LoginResponse>(
                future: _loginResponseFuture,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  } else if (snap.data?.token == null ||
                      snap.data!.token!.isEmpty ||
                      snap.data!.expiration!.isAfter(DateTime.now())) {
                    return const LoginScreen();
                  } else {
                    return HomePageScreen(loginResponse: snap.data!);
                  }
                });
          }
        }),
      ),
    );
  }

  @override
  void dispose() {
    logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorDark,
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            AnimatedBuilder(
                animation: logoController,
                builder: (BuildContext context, Widget? child) =>
                    ScaleTransition(
                      scale: scaleAnim,
                      child: Image.asset(
                        logo,
                        opacity: opacityAnim,
                        color: Theme.of(context).primaryColor,
                      ),
                    )),
            AnimatedBuilder(
              animation: appNameController,
              builder: (context, child) => Positioned(
                bottom: positionAnim.value,
                child: Opacity(
                  opacity: appNameOpacityAnim.value,
                  child: Text(
                    'E-Touch',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: 24,
                        fontFamily: 'audio'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
