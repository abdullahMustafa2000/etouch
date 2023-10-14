import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/navigation_bottom_manager.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/side_menu_model.dart';
import 'package:etouch/ui/screens/login_screen.dart';
import 'package:etouch/ui/themes/theme_manager.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import 'home_pages/home_fragments.dart';

int animDuration = 600;

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({Key? key, required this.loginResponse})
      : super(key: key);
  final LoginResponse loginResponse;
  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  MyApiServices get services => GetIt.I<MyApiServices>();
  late ThemeManager themeManager = ThemeManager();
  bool isDark = false;
  TabController? _tabsController;
  @override
  void initState() {
    _tabsController = TabController(length: 3, vsync: this);
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
          setState(() {});
        },
        onContactClkd: () {},
        onBackClkd: () {
          _key.currentState?.closeDrawer();
        },
        onLogoutClkd: () {
          logoutUser(context);
        },
      ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        isRTL(context) ? rotatedSideMenuIcon : sideMenuIcon,
                        color: Theme.of(context).primaryColor,
                      ),
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
                    size: 28,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 42,
            ),
            Expanded(
                child: Fragments(
              loginResponse: widget.loginResponse,
              services: services,
            ))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: pureWhite,
        ),
        child: TabBar(
          controller: _tabsController,
          indicatorColor: primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 2.5,
          overlayColor: MaterialStateProperty.all(
            Colors.white,
          ),
          onTap: (index) {
            bottomNavigator.updatePageIndex(index);
          },
          labelStyle: const TextStyle(
            fontSize: 0,
          ),
          labelColor: Colors.white,
          unselectedLabelStyle: const TextStyle(
            fontSize: 11,
          ),
          tabs: [
            Tab(
                icon: Image.asset(
              bottomNavigator.indexOfPage == 0
                  ? bottomNavHome
                  : unSelectedNavHome,
              width: 24,
              height: 24,
            )),
            Tab(
                icon: Image.asset(
                    bottomNavigator.indexOfPage == 1
                        ? bottomNavSend
                        : unSelectedNavSend,
                    width: 24,
                    height: 24)),
            Tab(
                icon: Image.asset(
              bottomNavigator.indexOfPage == 2
                  ? bottomNavDoc
                  : unSelectedNavDoc,
              width: 24,
              height: 24,
            )),
          ],
        ),
      ),
    );
  }
}
