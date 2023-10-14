import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/classes/document_for_listing.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/elements/purple_btn.dart';
import 'package:etouch/ui/screens/after_submission_screen.dart';
import 'package:etouch/ui/screens/e-invoice/e_invoice_doc_taxes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../../api/api_models/sales_order.dart';
import '../../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../e-invoice/doc_pre_requirments.dart';
import '../../e-invoice/products_widget.dart';

class CreateEInvoiceDocumentFragment extends StatelessWidget {
  const CreateEInvoiceDocumentFragment(
      {Key? key,
      required this.loginResponse,
      required this.currenciesList,
      required this.paymentMethodsList})
      : super(key: key);
  final LoginResponse loginResponse;
  final List<BaseAPIObject>? currenciesList, paymentMethodsList;
  MyApiServices get service => GetIt.I<MyApiServices>();
  @override
  Widget build(BuildContext context) {
    var docProvider = Provider.of<EInvoiceDocProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            OrderPreRequirementsWidget(
              branchesList: loginResponse.userBranches,
              token: loginResponse.token ?? '',
              services: service,
              salesOrder: docProvider.salesOrder,
            ),
            // divider,
            const SizedBox(
              height: 8,
            ),

            // add product details object
            ProductsSelectionWidget(
              loginResponse: loginResponse,
            ),
            const SizedBox(
              height: 24,
            ),

            DocumentNumbers(
              services: service,
              token: loginResponse.token ?? '',
            ),
            const SizedBox(
              height: 24,
            ),

            //send document btn
            SizedBox(
              width: double.infinity,
              child: PurpleButtonModel(
                content: Text(
                  appTxt(context).sendDocument,
                  style: txtTheme(context)
                      .titleLarge!
                      .copyWith(color: appTheme(context).primaryColorDark),
                ),
                onTap: () {
                  _submitDocument(docProvider.salesOrder,
                      loginResponse.token ?? '', context);
                },
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _submitDocument(
      SalesOrder order, String token, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AfterSubmissionScreen(
          hasError: false,
          document: DocumentForListing(
              type: 'Purchases',
              id: 1,
              registrationId: 12,
              ownerName: 'Hesham',
              submissionDate: DateTime.now(),
              totalAmount: 12000,
              status: 'valid'),
          errorMessage: 'not sending because...',
        ),
      ),
    );
  }
}
