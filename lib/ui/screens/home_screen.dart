import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/navigation_bottom_manager.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/side_menu_model.dart';
import 'package:etouch/ui/themes/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'home-pages/home_fragments.dart';

int animDuration = 600;

class HomePageScreen extends StatefulWidget {
  HomePageScreen({required this.loginResponse});
  LoginResponse loginResponse;
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  MyApiServices get services => GetIt.I<MyApiServices>();
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
    var bottomNavigator = Provider.of<BottomNavigationProvider>(context);
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
            Expanded(
                child: Fragments(loginResponse: widget.loginResponse)
            )
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
          const Icon(Icons.add),
          Image.asset(eReceiptNavIcon),
        ],
        onTap: (index) {
          bottomNavigator.updatePageIndex(index);
        },
      ),
    );
  }
}
