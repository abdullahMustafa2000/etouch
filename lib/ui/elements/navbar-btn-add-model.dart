import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../businessLogic/providers/navbar_add_btn_manager.dart';
import '../screens/home_screen.dart';
import '../themes/themes.dart';

class NavBarAddBtn extends StatefulWidget {
  const NavBarAddBtn({Key? key}) : super(key: key);

  @override
  State<NavBarAddBtn> createState() => _NavBarAddBtnState();
}

class _NavBarAddBtnState extends State<NavBarAddBtn> {
  bool opened = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    opened = context.watch<NavBarBtnsProvider>().getBtnState;
    return AnimatedContainer(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(180)),
          color: opened ? closeColor : Theme.of(context).primaryColor,
        ),
        duration: Duration(milliseconds: animDuration),
        child: AnimatedRotation(
          turns: opened ? 1 / 8 : 0,
          duration: const Duration(milliseconds: 100),
          child: Icon(
            Icons.add,
            size: 22,
            color: Theme.of(context).primaryColorDark,
          ),
        ));
  }
}
