import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/side_menu_model.dart';
import 'package:etouch/ui/screens/einvoice/e_invoice_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePageScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: SideMenuModel(
          taxPayerName: 'Abdullah',
          isDarkMood: false,
          taxPayerImg: '',
          onChangeMood: (isDark) {},
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
                      sideMenuIcon,
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
                  Image.asset(
                    logo,
                    width: 60,
                    height: 60,
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
            // pageview
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
