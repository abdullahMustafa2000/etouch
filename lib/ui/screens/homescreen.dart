import 'dart:ui';

import 'package:etouch/businessLogic/providers/nav_bar_add_btn.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/side_menu_model.dart';
import 'package:etouch/ui/screens/einvoice/create_document.dart';
import 'package:etouch/ui/screens/einvoice/e_invoice_dashboard.dart';
import 'package:etouch/ui/themes/theme_manager.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

int animDuration = 600;

class HomePageScreen extends StatefulWidget {
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late ThemeManager themeManager = ThemeManager();
  bool isDark = false;
  @override
  void initState() {
    super.initState();
    getCurrentThemeMode();
  }

  void getCurrentThemeMode() async {
    isDark = await themeManager.themePref.getTheme();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    themeManager = Provider.of<ThemeManager>(context);
    return Scaffold(
      key: _key,
      backgroundColor: Theme.of(context).primaryColorDark,
      drawer: SideMenuModel(
          taxPayerName: 'Abdullah',
          isDarkMood: isDark,
          taxPayerImg: '',
          onChangeMood: (isDark) {
            themeManager.toggleTheme(isDark);
          },
          onSavesClkd: () {},
          onSentClkd: () {},
          onContactClkd: () {},
          onLogoutClkd: () {}),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    child: Image.asset(
                      isRTL(context) ? rotatedSideMenuIcon : sideMenuIcon,
                      color: Theme.of(context).primaryColor,
                    ),
                    onTap: () {
                      if (!_key.currentState!.isDrawerOpen) {
                        _key.currentState?.openDrawer();
                      } else {
                        _key.currentState?.closeDrawer();
                      }
                    },
                  ),
                  Builder(builder: (context) {
                    return Image.asset(
                      logo,
                      width: 60,
                      height: 60,
                      color: Theme.of(context).primaryColor,
                    );
                  }),
                  Icon(
                    Icons.notifications_sharp,
                    color: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 42,
            ),
            HomePageView(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 1,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.transparent,
        items: [
          Image.asset(eInvoiceNavIcon),
          const NavBarAddBtn(),
          Image.asset(eReceiptNavIcon),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              {
                context.read<NavBarBtnsProvider>().addBtnClosed();
                context
                    .read<NavBarBtnsProvider>()
                    .eInvoiceEReceiptBtnClicked(index);
                break;
              }
            case 1:
              {
                context.read<NavBarBtnsProvider>().changeAddBtnState();
                break;
              }
            case 2:
              {
                context.read<NavBarBtnsProvider>().addBtnClosed();
                context
                    .read<NavBarBtnsProvider>()
                    .eInvoiceEReceiptBtnClicked(index-1);
                break;
              }
          }
        },
      ),
    );
  }
}

class NavBarAddBtn extends StatefulWidget {
  const NavBarAddBtn({Key? key}) : super(key: key);

  @override
  State<NavBarAddBtn> createState() => _NavBarAddBtnState();
}

class _NavBarAddBtnState extends State<NavBarAddBtn>
    with TickerProviderStateMixin {
  late AnimationController opacityController;
  late Animation<double> opacityAnim;
  double vMovement = 62, hMovement = 52;
  bool opened = false;
  @override
  void initState() {
    super.initState();
    opacityController = AnimationController(
        vsync: this, duration: Duration(milliseconds: animDuration));
    opacityAnim = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: opacityController, curve: Curves.fastOutSlowIn));
  }

  @override
  Widget build(BuildContext context) {
    opened = context.watch<NavBarBtnsProvider>().getBtnState;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        AnimatedPositioned(
          duration: Duration(milliseconds: animDuration),
          bottom: opened ? vMovement : 0,
          left: opened ? hMovement : 0,
          child: AnimatedOpacity(
            opacity: opened ? 1 : 0,
            duration: Duration(milliseconds: animDuration),
            child: Column(
              children: [
                Image.asset(
                  eInvoiceNavIcon,
                  width: 39,
                  height: 39,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  AppLocalizations.of(context)!.sendEInvoiceTitle,
                  //'${vMovementAnim.value}',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: animDuration),
          bottom: opened ? vMovement : 0,
          right: opened ? hMovement : 0,
          child: AnimatedOpacity(
            opacity: opened ? 1 : 0,
            duration: Duration(milliseconds: animDuration),
            child: Column(
              children: [
                Image.asset(
                  eReceiptNavIcon,
                  width: 39,
                  height: 39,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  AppLocalizations.of(context)!.sendEReceiptTitle,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ),
        AnimatedContainer(
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
            )),
      ],
    );
  }
}

class HomePageView extends StatefulWidget {
  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late PageController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  void moveToPage(PageController controller, int index) {
    controller.animateToPage(index,
        duration: Duration(milliseconds: animDuration), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    var navBtnProvider = context.watch<NavBarBtnsProvider>();
    bool addBtnOpened = navBtnProvider.getBtnState;
    int btnIndex = navBtnProvider.getBtnIndex;
    if (_controller.hasClients) {
      moveToPage(_controller, btnIndex);
    }
    return Expanded(
      child: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            children: [
              const EInvoiceDashboardScreen(),
              Center(
                child: Text(
                  'Hello from E-Receipt',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
          AnimatedOpacity(
            opacity: addBtnOpened ? 1 : 0,
            duration: Duration(milliseconds: animDuration),
            child: Container(
              height: addBtnOpened ? double.infinity : 0,
              color: Colors.white.withOpacity(.6),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
