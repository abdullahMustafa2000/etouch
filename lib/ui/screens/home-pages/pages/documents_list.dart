import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/document_for_listing_model.dart';
import 'package:etouch/ui/elements/editable_data.dart';
import 'package:etouch/ui/elements/purple_btn.dart';
import 'package:etouch/ui/elements/searchable_dropdown_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

class EInvoicesListFragment extends StatelessWidget {
  EInvoicesListFragment({Key? key, required this.loginResponse})
      : super(key: key);
  LoginResponse loginResponse;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            //title
            //list of search options
            SearchView(
              loginResponse: loginResponse,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 1,
              width: MediaQuery.of(context).size.width / 2,
              color: Colors.black,
            ),
            //documents list
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 9),
                    child: DocumentForListingWidget(
                        cardTitle: 'Title',
                        registrationId: 123456789.toString(),
                        customerName: 'Hesham',
                        submissionDate: DateTime.now().toString(),
                        totalAmount: 12000.toString(),
                        status: 'valid'),
                  );
                },
                itemCount: 10,
                scrollDirection: Axis.vertical,
              ),
            ),
            const SizedBox(height: 20,),
            //total amount view
            Container(
              width: MediaQuery.of(context).size.width / 1.5,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: lighterSecondaryClr,
                borderRadius:
                    const BorderRadius.all(Radius.circular(cornersRadiusConst)),
              ),
              child: Center(
                child: Text(
                  'Hello',
                  style: txtTheme(context)
                      .titleMedium!
                      .copyWith(color: primaryColor),
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
                data: '', onChange: (txt) {}, hasInitValue: false),
            context),
        _searchRow(
            appTxt(context).localNumber,
            EditableInputData(
                data: '', onChange: (txt) {}, hasInitValue: false),
            context),
        _searchRow(
            appTxt(context).submissionNumber,
            EditableInputData(
                data: '', onChange: (txt) {}, hasInitValue: false),
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
              style: txtTheme(context).titleLarge!.copyWith(color: pureWhite),
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
                  .labelLarge!
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
