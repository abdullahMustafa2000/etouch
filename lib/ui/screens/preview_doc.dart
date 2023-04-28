import 'package:etouch/main.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class DocumentPreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(cornersRadiusConst)),
            gradient: LinearGradient(
                colors: [accentColor, primaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: const Center(
            child: InvoiceTopContainer(),
          ),
        ),
      ],
    );
  }
}

class InvoiceTopContainer extends StatelessWidget {
  const InvoiceTopContainer({Key? key}) : super(key: key);

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
              Expanded(child: _dataRow(appTxt(context).localNumber, 'info', context)),
              Expanded(
                child: _dataRow(
                    appTxt(context).statusDocumentForListing, 'info', context),
              ),
            ],
          ),
          _dataRow(appTxt(context).documentSubmissionDate, 'info', context),
          Container(
            color: pureWhite,
            height: .3,
            width: double.infinity,
          ),
          _dataRow(appTxt(context).sellerName, 'name', context),
          _dataRow(appTxt(context).eTaxRegistrationId, 'info', context),
          _dataRow(appTxt(context).typeOfDocSides, 'info', context),
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
