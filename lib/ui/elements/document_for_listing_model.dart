import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

class DocumentForListingWidget extends StatelessWidget {
  String status,
      cardTitle,
      registrationId,
      customerName,
      submissionDate,
      totalAmount;
  DocumentForListingWidget(
      {required this.cardTitle,
      required this.registrationId,
      required this.customerName,
      required this.submissionDate,
      required this.totalAmount,
      required this.status});
  @override
  Widget build(BuildContext context) {
    Map<String, Color> txtClr = {
      'valid': greenCardTitleClr,
      'invalid': pureWhite,
      'rejected': lightRedCardTitleClr,
      'cancelled': pureWhite,
    };
    Map<String, Color> bgClr = {
      'valid': greenCardBGClr,
      'invalid': darkRedCardBGClr,
      'rejected': lightRedCardBGClr,
      'cancelled': purpleCardBGClr,
    };
    Map<String, String> icon = {
      'valid': greenDBCardIcon,
      'invalid': darkRedDBCardIcon,
      'rejected': lightRedDBCardIcon,
      'cancelled': purpleDBCardIcon,
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.all(Radius.circular(cornersRadiusConst)),
            color: bgClr[status],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      cardTitle,
                      style: txtTheme(context)
                          .titleLarge!
                          .copyWith(color: txtClr[status]),
                    ),
                    Image.asset(icon[status]!),
                  ],
                ),
              ),
              _dataRow(appTxt(context).customerRegistrationNumber,
                  registrationId, txtClr[status], context),
              _dataRow(appTxt(context).customerName, customerName,
                  txtClr[status], context),
              _dataRow(appTxt(context).documentSubmissionDate,
                  submissionDate, txtClr[status], context),
              _dataRow(appTxt(context).totalPriceForListing, totalAmount,
                  txtClr[status], context),
              _dataRow(appTxt(context).statusDocumentForListing, status,
                  txtClr[status], context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dataRow(
      String label, String data, Color? txtClr, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: txtTheme(context).titleMedium!.copyWith(color: txtClr, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            data,
            style: txtTheme(context).labelLarge!.copyWith(color: txtClr, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
