import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';
import 'package:etouch/businessLogic/providers/home_screens_manager.dart';
import 'package:etouch/ui/screens/home-pages/pages/e_receipt_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../businessLogic/providers/navbar_add_btn_manager.dart';
import '../e-invoice/create_document.dart';
import 'pages/e_invoice_dashboard.dart';
import '../home_screen.dart';

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
        const EInvoiceDashboardFragment(),
        //switch between (choices & documents) screen
        CreateEInvoiceDocumentFragment(
          companyId: 1,
          branches: [BaseAPIObject(id: 1, name: 'Branch1')],
        ),
        const EInvoicesListFragment(),
      ],
    );
  }
}
