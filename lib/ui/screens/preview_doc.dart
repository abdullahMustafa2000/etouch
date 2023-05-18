import 'package:etouch/businessLogic/classes/document_for_listing.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:etouch/ui/elements/uneditable_data.dart';
import 'package:etouch/ui/elements/primary_btn_model.dart';
import '../constants.dart';

class DocumentPreviewScreen extends StatelessWidget {
  DocumentPreviewScreen({required this.document});
  DocumentForListing document;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      color: appTheme(context).primaryColorDark,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // top information
          Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.all(Radius.circular(cornersRadiusConst)),
              gradient: LinearGradient(
                  colors: [accentColor, primaryColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: Center(
              child: InvoiceTopContainer(documentInfo: document),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MoneyDetailsWidget(),
          const SizedBox(
            height: 24,
          ),
          BtnsWidgt(),
        ],
      ),
    );
  }
}

class InvoiceTopContainer extends StatelessWidget {
  InvoiceTopContainer({Key? key, required this.documentInfo}) : super(key: key);
  DocumentForListing documentInfo;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          Text(
            'Invoice 0.9',
            style: txtTheme(context).displayMedium!.copyWith(color: pureWhite),
          ),
          const SizedBox(
            height: 30,
          ),
          _dataRow(appTxt(context).submissionNumber, 'info', context),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  child:
                      _dataRow(appTxt(context).localNumber, 'info', context)),
              Expanded(
                child: _dataRow(appTxt(context).statusDocumentForListing,
                    documentInfo.status, context),
              ),
            ],
          ),
          _dataRow(appTxt(context).documentSubmissionDate,
              getFormattedDate(documentInfo.submissionDate), context),
          Container(
            color: pureWhite,
            height: .3,
            width: double.infinity,
          ),
          _dataRow(appTxt(context).sellerName, documentInfo.ownerName, context),
          _dataRow(appTxt(context).eTaxRegistrationId,
              documentInfo.registrationId.toString(), context),
          _dataRow(appTxt(context).typeOfDocSides, documentInfo.type, context),
          _dataRow(appTxt(context).addressOfDocSides, 'info', context),
          Container(
            color: pureWhite,
            height: .3,
            width: double.infinity,
          ),
          _dataRow(appTxt(context).buyerName, 'name', context),
          _dataRow(appTxt(context).eTaxRegistrationId, 'info', context),
          _dataRow(appTxt(context).typeOfDocSides, 'info', context),
          _dataRow(appTxt(context).addressOfDocSides, 'info', context),
        ],
      ),
    );
  }

  Widget _dataRow(String label, String info, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: txtTheme(context).labelLarge!.copyWith(color: pureWhite),
          ),
          Text(
            info,
            style: txtTheme(context).titleMedium!.copyWith(color: pureWhite),
          ),
        ],
      ),
    );
  }

  Widget _sellerBuyerInfo(String name, String registrationNum, String type,
      String address, BuildContext context) {
    return Column(
      children: [],
    );
  }
}

class MoneyDetailsWidget extends StatelessWidget {
  const MoneyDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
      decoration: BoxDecoration(
          border: Border.all(color: accentColor, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(cornersRadiusConst))),
      child: Column(
        children: [
          _dataRow(appTxt(context).totalTxt, 1299.toString(), context),
          _dataRow(appTxt(context).totalTxt, 2323.toString(), context),
          _dataRow(appTxt(context).totalTxt, 12.toString(), context),
          _dataRow(appTxt(context).totalTxt, 0.toString(), context),
          _dataRow(appTxt(context).totalTxt, 100.toString(), context),
        ],
      ),
    );
  }

  Widget _dataRow(String label, String data, BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
                child: Text(
              label,
              style: txtTheme(context)
                  .titleMedium!
                  .copyWith(color: appTheme(context).primaryColor),
              overflow: TextOverflow.ellipsis,
            )),
            Expanded(child: UnEditableData(data: data)),
          ],
        ),
      );
}

class BtnsWidgt extends StatelessWidget {
  const BtnsWidgt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: PrimaryClrBtnModel(
              content: Text(
                appTxt(context).cancelDocument,
                style:
                    txtTheme(context).titleMedium!.copyWith(color: pureWhite),
              ),
              onPressed: () {},
              color: closeColor),
        )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: PrimaryClrBtnModel(
              content: Text(
                appTxt(context).downloadDocument,
                style: txtTheme(context)
                    .titleMedium!
                    .copyWith(color: primaryColor),
              ),
              onPressed: () {},
              color: lighterSecondaryClr,
            ),
          ),
        ),
      ],
    );
  }
}
