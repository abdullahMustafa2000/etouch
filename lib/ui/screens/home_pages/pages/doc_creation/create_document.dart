import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/classes/document_for_listing.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/elements/purple_btn.dart';
import 'package:etouch/ui/elements/request_api_widget.dart';
import 'package:etouch/ui/screens/after_submission_screen.dart';
import 'package:provider/provider.dart';
import 'e-invoice/e_invoice_doc_taxes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api/api_models/sales_order.dart';
import '../../../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import 'e-invoice/doc_pre_requirments.dart';
import 'e-invoice/products_list_widget.dart';

class CreateEInvoiceDocumentFragment
    extends StatelessWidget {
  CreateEInvoiceDocumentFragment(
      {Key? key,
        required this.loginResponse,})
      : super(key: key);
  final LoginResponse loginResponse;

  MyApiServices get service => GetIt.I<MyApiServices>();

  SalesOrder salesOrder = SalesOrder();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              OrderPreRequirementsWidget(
                salesOrder: salesOrder,
                loginResponse: loginResponse,
                service: service,
              ),
              // divider,
              const SizedBox(
                height: 8,
              ),

              // add product details object
              ProductsSelectionWidget(
                loginResponse: loginResponse,
                salesOrder: salesOrder,
              ),
              const SizedBox(
                height: 24,
              ),
              DocumentNumbers(
                services: service,
                token: loginResponse.token ?? '',
                salesOrder: salesOrder,
                companyId: loginResponse.companyId ?? 0,
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
                    _submitDocument(
                        salesOrder, loginResponse.token ?? '', context);
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
