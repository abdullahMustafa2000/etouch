import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/side_menu_model.dart';
import 'package:etouch/ui/screens/einvoice/e_invoice_dashboard.dart';
import 'package:etouch/ui/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';

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
    setState(() {

    });
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
                      isRTL(context)?rotatedSideMenuIcon:sideMenuIcon,
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
                  Builder(
                    builder: (context) {
                      return Image.asset(
                        logo,
                        width: 60,
                        height: 60,
                        color: Theme.of(context).primaryColor,
                      );
                    }
                  ),
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
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.transparent,
        items: [
          Image.asset(eInvoiceNavIcon),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(180)),
            ),
            child: Icon(
              Icons.add,
              size: 22,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          Image.asset(eReceiptNavIcon),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
          }
        },
      ),
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
    _controller = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: _controller,
        children: const [
          EInvoiceDashboardScreen(),
          Center(
            child: Text('Hello from E-Receipt'),
          ),
        ],
      ),
    );
  }
}
