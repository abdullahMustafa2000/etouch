import 'package:etouch/businessLogic/providers/home-screens-manager.dart';
import 'package:etouch/ui/screens/home-pages/pages/e-receipt-dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../businessLogic/providers/navbar-add-btn-manager.dart';
import '../e-invoice/create-document.dart';
import 'pages/e-invoice-dashboard.dart';
import '../e-receipt/create-document.dart';
import '../home-screen.dart';
import 'pages/send-documents-selection.dart';

class Fragments extends StatefulWidget {
  Fragments({Key? key}) : super(key: key);
  @override
  State<Fragments> createState() => _FragmentsState();
}

class _FragmentsState extends State<Fragments> {
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  void moveToPage(PageController controller, int index) {
    controller.animateToPage(index,
        duration: Duration(milliseconds: animDuration),
        curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    var navBtnProvider = context.watch<NavBarBtnsProvider>();
    var fragmentsProvider = context.watch<HomePagesSwitcher>();
    bool fragmentsState = fragmentsProvider.getFragmentState;
    int stackIndex = fragmentsProvider.getScreenIndex;
    if (_controller.hasClients) {
      moveToPage(_controller, navBtnProvider.getBtnIndex);
    }
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _controller,
      children: [
        const EInvoiceDashboardScreen(),
        //switch between (choices & documents) screen
        Stack(
          children: [
            Visibility(
                visible: !fragmentsState, child: EStack(index: stackIndex)),
            Visibility(visible: fragmentsState, child: HomeGlassyScreen()),
          ],
        ),
        const EReceiptDashboard(),
      ],
    );
  }
}

class EStack extends StatelessWidget {
  EStack({required this.index});
  int index;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
            visible: index == 0, child: CreateEInvoiceDocumentScreen()),
        Visibility(
            visible: index == 1, child: CreateEReceiptDocumentScreen()),
      ],
    );
  }
}
