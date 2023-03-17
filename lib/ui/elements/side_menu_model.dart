import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideMenuModel extends StatelessWidget {
  SideMenuModel(
      {required this.taxPayerName,
      required this.isDarkMood,
      required this.taxPayerImg,
      required this.onChangeMood});
  String taxPayerName;
  String taxPayerImg;
  bool isDarkMood;
  Function onChangeMood;
  @override
  Widget build(BuildContext context) {
    return Container(
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
          MenuTopView(),
          const SizedBox(
            height: 28,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: secondaryColor,
          ),
          MenuProfileWidget(userName: taxPayerName, userImg: taxPayerImg ?? 'assets/images/fakeImage.png'),
          SideMenuOptionsWidget(
            onChangeMood: onChangeMood,
          ),
          const Expanded(
              child: Padding(
            padding: EdgeInsets.all(0),
          )),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.logout_sharp,
                  color: Theme.of(context).primaryColorDark,
                ),
                const Padding(padding: EdgeInsets.only(left: 8)),
                Text(
                  AppLocalizations.of(context)!.logoutTxt,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MenuTopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Image.asset(whiteLogo),
            Text(
              'E-Touch',
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'audio'),
            ),
            Expanded(child: Container()),
            Align(
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
          ],
        ),
      ),
    );
  }
}

class MenuProfileWidget extends StatelessWidget {
  MenuProfileWidget({required this.userName, required this.userImg});
  String userName, userImg;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(top: 21),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/fakeImage.png'),
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 6)),
            Text(
              userName,
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge!
                  .copyWith(color: Theme.of(context).primaryColorDark),
            ),
          ],
        ));
  }
}

class SideMenuOptionsWidget extends StatelessWidget {
  SideMenuOptionsWidget({this.onChangeMood});
  Function? onChangeMood;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 38),
      child: Column(
        children: [
          MenuItemWidget(
              title: AppLocalizations.of(context)!.savedFilesTxt,
              prefix: Icons.stars,
              isNightMood: false),
          MenuItemWidget(
              title: AppLocalizations.of(context)!.sentFilesTxt,
              prefix: Icons.upload_file_outlined,
              isNightMood: false),
          MenuItemWidget(
              title: AppLocalizations.of(context)!.darkModeTxt,
              prefix: Icons.dark_mode_outlined,
              isNightMood: true,
          onChangeMood: onChangeMood,),
          MenuItemWidget(
              title: AppLocalizations.of(context)!.loginContactUsTxt,
              prefix: Icons.local_phone_outlined,
              isNightMood: false),
        ],
      ),
    );
  }
}

class MenuItemWidget extends StatefulWidget {
  MenuItemWidget(
      {required this.title,
      required this.prefix,
      required this.isNightMood,
      this.onChangeMood});
  IconData prefix;
  String title;
  bool isNightMood;
  Function? onChangeMood;
  @override
  State<MenuItemWidget> createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  bool _toggle = false;
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
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Theme.of(context).primaryColorDark),
          ),
          const Expanded(
              child: Padding(
            padding: EdgeInsets.all(0),
          )),
          Visibility(
            visible: widget.isNightMood,
            child: CustomSwitch(
                value: _toggle,
                onChanged: (bool val) {
                  setState(() {
                    _toggle = val;
                    widget.onChangeMood!(val);
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
        vsync: this, duration: const Duration(milliseconds: 50));
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
