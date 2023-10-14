import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/businessLogic/providers/navigation_bottom_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/screens/home_pages/pages/documents_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import 'pages/create_document.dart';
import 'pages/e_invoice_dashboard.dart';
import '../home_screen.dart';

class Fragments extends StatefulWidget {
  const Fragments(
      {Key? key, required this.loginResponse, required this.services})
      : super(key: key);
  final LoginResponse loginResponse;
  final MyApiServices services;
  @override
  State<Fragments> createState() => _FragmentsState();
}

class _FragmentsState extends State<Fragments> {
  final PageController _controller = PageController();
  late Future<List<BaseAPIObject>?> _paymentMethods, _currencies;

  @override
  void initState() {
    _paymentMethods = _getPaymentMethods();
    _currencies = _getCurrencies();
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
        FutureBuilder(
            future: Future.wait([_currencies, _paymentMethods]),
            builder: (context, AsyncSnapshot<List<List<BaseAPIObject>?>> snap) {
              if (snap.hasData) {
                context.watch<EInvoiceDocProvider>().salesOrder.branchId =
                    widget.loginResponse.userBranches!.first.getId;
                context.watch<EInvoiceDocProvider>().companyCurrencies =
                    snap.data?.first;
                context.watch<EInvoiceDocProvider>().companyPaymentMethods =
                    snap.data?.last;
                return CreateEInvoiceDocumentFragment(
                  loginResponse: widget.loginResponse,
                  currenciesList: snap.data?.first,
                  paymentMethodsList: snap.data?.last,
                );
              } else {
                return Center(
                  child: Text(appTxt(context).loginContactUsTxt),
                );
              }
            }),
        EInvoicesListFragment(loginResponse: widget.loginResponse),
      ],
    );
  }

  Future<List<BaseAPIObject>?> _getCurrencies() async {
    return (await widget.services.getCurrenciesList(
            widget.loginResponse.companyId ?? 0,
            widget.loginResponse.token ?? ''))
        .data;
  }

  Future<List<BaseAPIObject>?> _getPaymentMethods() async {
    return (await widget.services.getPaymentMethodsList(
            widget.loginResponse.companyId ?? 0,
            widget.loginResponse.token ?? ''))
        .data;
  }
}
