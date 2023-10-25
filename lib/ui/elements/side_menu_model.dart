import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

class SideMenuModel extends StatelessWidget {
  const SideMenuModel(
      {Key? key,
      required this.taxPayerName,
      required this.isDarkMood,
      required this.taxPayerImg,
      required this.onChangeMood,
      required this.onContactClkd,
      required this.onBackClkd,
      required this.onLogoutClkd})
      : super(key: key);
  final String taxPayerName;
  final String? taxPayerImg;
  final bool isDarkMood;
  final Function onChangeMood, onContactClkd, onLogoutClkd, onBackClkd;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width * .7,
        padding: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            MenuTopView(
              onBackClkd: onBackClkd,
            ),
            const SizedBox(
              height: 28,
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: secondaryColor,
            ),
            MenuProfileWidget(
                userName: taxPayerName,
                userImg: taxPayerImg ?? 'assets/images/logo.png'),
            SideMenuOptionsWidget(
              onChangeMood: onChangeMood,
              onContactClkd: onContactClkd,
              onLogoutClkd: onLogoutClkd,
              isDark: isDarkMood,
            ),
          ],
        ),
      ),
    );
  }
}

class MenuTopView extends StatelessWidget {
  const MenuTopView({Key? key, required this.onBackClkd}) : super(key: key);
  final Function onBackClkd;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              logo,
              width: 46,
              height: 49,
              color: Theme.of(context).primaryColorDark,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'E-Touch',
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'audio'),
              ),
            ),
            Expanded(child: Container()),
            InkWell(
              onTap: () {
                onBackClkd();
              },
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 17,
                    ),
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

class MenuProfileWidget extends StatelessWidget {
  const MenuProfileWidget(
      {Key? key, required this.userName, required this.userImg})
      : super(key: key);
  final String userName, userImg;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(top: 21),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(userImg),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
            Text(
              userName,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).primaryColorDark,
                  fontFamily: almarai),
            ),
          ],
        ));
  }
}

class SideMenuOptionsWidget extends StatelessWidget {
  const SideMenuOptionsWidget(
      {Key? key, required this.onChangeMood,
      required this.onContactClkd,
      required this.onLogoutClkd,
      required this.isDark}) : super(key: key);
  final Function onChangeMood;
  final Function onContactClkd, onLogoutClkd;
  final bool isDark;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 38),
      child: Column(
        children: [
          MenuItemWidget(
            title: appTxt(context).darkModeTxt,
            prefix: Icons.dark_mode_outlined,
            isNightMood: true,
            isDark: isDark,
            onChangeMood: (isDark) {
              onChangeMood(isDark);
            },
          ),
          InkWell(
            onTap: () {
              onContactClkd();
            },
            child: MenuItemWidget(
              title: appTxt(context).loginContactUsTxt,
              prefix: Icons.local_phone_outlined,
            ),
          ),
          InkWell(
            onTap: () {
              onLogoutClkd();
            },
            child: MenuItemWidget(
                title: appTxt(context).logoutTxt, prefix: Icons.logout_sharp),
          )
        ],
      ),
    );
  }
}

class MenuItemWidget extends StatefulWidget {
  const MenuItemWidget(
      {Key? key, required this.title,
      required this.prefix,
      this.isNightMood,
      this.onChangeMood,
      this.isDark}) : super(key: key);
  final IconData prefix;
  final String title;
  //show/hide Switch  , setValue
  final bool? isNightMood;
  final bool? isDark;
  final Function? onChangeMood;
  @override
  State<MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  late bool _toggle;
  @override
  void initState() {
    super.initState();
    _toggle = widget.isDark ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            widget.prefix,
            color: Theme.of(context).primaryColorDark,
          ),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 7.5)),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).primaryColorDark, fontFamily: almarai),
          ),
          const Expanded(
              child: Padding(
            padding: EdgeInsets.all(0),
          )),
          Visibility(
            visible: widget.isNightMood ?? false,
            child: CustomSwitch(
                value: _toggle,
                onChanged: (val) {
                  widget.onChangeMood!(val);
                  setState(() {
                    _toggle = val;
                  });
                }),
          ),
        ],
      ),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: Container(
            width: 38.0,
            height: 18.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: primaryColor, width: 1),
              color: pureWhite,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              child: Container(
                alignment:
                    widget.value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: !widget.value ? switchThumbColor : primaryColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
