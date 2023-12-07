import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/document_for_listing_model.dart';
import 'package:etouch/ui/elements/editable_data.dart';
import 'package:etouch/ui/elements/purple_btn.dart';
import 'package:etouch/ui/elements/searchable_dropdown_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import '../../../businessLogic/classes/document_for_listing.dart';
import '../preview_doc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EInvoicesListFragment extends StatelessWidget {
  EInvoicesListFragment({Key? key, required this.loginResponse})
      : super(key: key);
  LoginResponse loginResponse;
  var list = ['valid', 'invalid', 'rejected', 'cancelled'];
  List<DocumentForListing> documents = [
    DocumentForListing(
        type: 'Purchases',
        id: 1,
        registrationId: 12,
        ownerName: 'Hesham',
        submissionDate: DateTime.now(),
        totalAmount: 12000,
        status: 'valid'),
    DocumentForListing(
        type: 'Sales',
        id: 1,
        registrationId: 22,
        ownerName: 'Mohamed',
        submissionDate: DateTime.now(),
        totalAmount: 13000,
        status: 'invalid'),
    DocumentForListing(
        type: 'Purchases',
        id: 1,
        registrationId: 32,
        ownerName: 'Ali',
        submissionDate: DateTime.now(),
        totalAmount: 14000,
        status: 'rejected'),
    DocumentForListing(
        type: 'Sales',
        id: 1,
        registrationId: 42,
        ownerName: 'Mustafa',
        submissionDate: DateTime.now(),
        totalAmount: 15000,
        status: 'cancelled'),
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            //title
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                appTxt(context).eInvoicesListTitle,
                style: txtTheme(context)
                    .displayLarge!
                    .copyWith(color: appTheme(context).primaryColor),
              ),
            ),
            //list of search options
            SearchView(
              loginResponse: loginResponse,
            ),
            //separation line
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 1,
              width: MediaQuery.of(context).size.width / 2,
              color: appTheme(context).primaryColor,
            ),
            //documents list
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 9),
                    child: InkWell(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => SingleChildScrollView(
                            controller: ModalScrollController.of(context),
                            child: DocumentPreviewScreen(document: documents[index]),
                          ),
                        );
                      },
                      child: DocumentForListingWidget(
                          cardTitle: documents[index].type,
                          registrationId:
                              documents[index].registrationId.toString(),
                          customerName: documents[index].ownerName,
                          submissionDate:
                              getZFormattedDate(documents[index].submissionDate),
                          totalAmount: documents[index].totalAmount.toString(),
                          status: documents[index].status),
                    ),
                  );
                },
                itemCount: documents.length,
                scrollDirection: Axis.vertical,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //total amount
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: lighterSecondaryClr,
                borderRadius:
                    const BorderRadius.all(Radius.circular(cornersRadiusConst)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        appTxt(context).totalTxt,
                        style: txtTheme(context)
                            .titleMedium!
                            .copyWith(color: primaryColor),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '69519.43',
                        style: txtTheme(context)
                            .titleMedium!
                            .copyWith(color: primaryColor, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}

class SearchView extends StatelessWidget {
  LoginResponse loginResponse;
  SearchView({required this.loginResponse});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchRow(
            appTxt(context).representationNumber,
            EditableInputData(
                data: '', onChange: (txt, isEmpty) {}, hasInitValue: false),
            context),
        _searchRow(
            appTxt(context).localNumber,
            EditableInputData(
                data: '', onChange: (txt, isEmpty) {}, hasInitValue: false),
            context),
        _searchRow(
            appTxt(context).submissionNumber,
            EditableInputData(
                data: '', onChange: (txt, isEmpty) {}, hasInitValue: false),
            context),
        _searchRow(
            appTxt(context).category,
            SearchDropdownMenuModel(
              dataList: [],
              onItemSelected: () {},
              selectedItem: null,
            ),
            context),
        _searchRow(
            appTxt(context).statusDocumentForListing,
            SearchDropdownMenuModel(
              dataList: [],
              onItemSelected: () {},
              selectedItem: null,
            ),
            context),
        const SizedBox(
          height: 20,
        ),
        PurpleButtonModel(
            content: Text(
              appTxt(context).searchHint,
              style:
                  txtTheme(context).headlineMedium!.copyWith(color: pureWhite),
            ),
            width: MediaQuery.of(context).size.width / 1.5,
            onTap: () {}),
      ],
    );
  }

  Widget _searchRow(String label, Widget searchType, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Text(
              label,
              style: txtTheme(context)
                  .titleLarge!
                  .copyWith(color: appTheme(context).primaryColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(child: searchType),
        ],
      ),
    );
  }
}
