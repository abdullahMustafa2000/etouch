import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/classes/document_for_listing.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/elements/purple_btn.dart';
import 'package:etouch/ui/screens/after_submission_screen.dart';
import 'package:provider/provider.dart';
import 'payment_info.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../../api/api_models/sales_order.dart';
import 'purple_top_widget.dart';
import 'products_list_widget.dart';

class CreateEInvoiceDocumentFragment extends StatefulWidget {
  const CreateEInvoiceDocumentFragment({
    Key? key,
    required this.loginResponse,
  }) : super(key: key);
  final LoginResponse loginResponse;

  @override
  State<CreateEInvoiceDocumentFragment> createState() =>
      _CreateEInvoiceDocumentFragmentState();
}

class _CreateEInvoiceDocumentFragmentState
    extends State<CreateEInvoiceDocumentFragment> {
  MyApiServices get service => GetIt.I<MyApiServices>();

  SalesOrder salesOrder = SalesOrder();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                OrderPreRequirementsWidget(
                  salesOrder: salesOrder,
                  loginResponse: widget.loginResponse,
                  service: service,
                ),
                // divider,
                const SizedBox(
                  height: 8,
                ),
                // add product details object
                ProductsSelectionWidget(
                  loginResponse: widget.loginResponse,
                  salesOrder: salesOrder,
                ),
                const SizedBox(
                  height: 24,
                ),
                DocumentNumbers(
                  services: service,
                  token: widget.loginResponse.token ?? '',
                  salesOrder: salesOrder,
                  companyId: widget.loginResponse.companyId ?? 0,
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
                          .copyWith(color: Colors.white),
                    ),
                    onTap: () {
                      _submitDocument(salesOrder,
                          widget.loginResponse.token ?? '', context);
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
      ),
    );
  }

  void _submitDocument(
      SalesOrder order, String token, BuildContext context) async {
    order.totalOrderAmount = context.read<EInvoiceDocProvider>().docTotalAmount;
    service.postDocument(order, token).then(
          (value) => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AfterSubmissionScreen(
                  hasError: value.hasError,
                  document: DocumentForListing(
                      type: 'Purchases',
                      id: 1,
                      registrationId: 12,
                      ownerName: 'Hesham',
                      submissionDate: DateTime.now(),
                      totalAmount: 12000,
                      status: 'valid'),
                  errorMessage: 'not sending because...\n${value.errorMessage}',
                ),
              ),
            )
          },
        );
  }
}
