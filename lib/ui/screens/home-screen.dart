import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/side-menu-model.dart';
import 'package:etouch/ui/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../../businessLogic/providers/home-screens-manager.dart';
import '../../businessLogic/providers/navbar-add-btn-manager.dart';
import '../elements/navbar-btn-add-model.dart';
import 'home-pages/home-fragments.dart';

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
    var homeSwitcher = context.watch<HomePagesSwitcher>();
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
            HomePageContent(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: 0,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.transparent,
        items: [
          Image.asset(eInvoiceNavIcon),
          const NavBarAddBtn(),
          Image.asset(eReceiptNavIcon),
        ],
        onTap: (index) {
          homeSwitcher.navBtnsClicked();
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
                context
                    .read<NavBarBtnsProvider>()
                    .eInvoiceEReceiptBtnClicked(index);
                break;
              }
            case 2:
              {
                context.read<NavBarBtnsProvider>().addBtnClosed();
                context
                    .read<NavBarBtnsProvider>()
                    .eInvoiceEReceiptBtnClicked(index);
                break;
              }
          }
        },
      ),
    );
  }
}

class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Fragments()
    );
  }
}
