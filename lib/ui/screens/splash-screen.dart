import 'dart:async';
import 'package:etouch/ui/screens/orientation/oriantationscreen.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
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
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => OrientaionScreen())));
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
                builder: (BuildContext context, Widget? child) => ScaleTransition(
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
