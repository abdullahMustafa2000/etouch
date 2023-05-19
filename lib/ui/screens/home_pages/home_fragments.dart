import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/businessLogic/providers/navigation_bottom_manager.dart';
import 'package:etouch/ui/screens/home_pages/pages/documents_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/create_document.dart';
import 'pages/e_invoice_dashboard.dart';
import '../home_screen.dart';

class Fragments extends StatefulWidget {
  const Fragments({Key? key, required this.loginResponse}) : super(key: key);
  final LoginResponse loginResponse;
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
    var bottomNavigator = context.watch<BottomNavigationProvider>();
    if (_controller.hasClients) {
      moveToPage(_controller, bottomNavigator.indexOfPage);
    }
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _controller,
      children: [
        EInvoiceDashboardFragment(loginResponse: widget.loginResponse),
        CreateEInvoiceDocumentFragment(
            loginResponse: widget.loginResponse,
        ),
        EInvoicesListFragment(loginResponse: widget.loginResponse),
      ],
    );
  }
}
