import 'package:etouch/businessLogic/classes/document_for_listing.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/purple_btn.dart';
import 'package:etouch/ui/screens/preview_doc.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../themes/themes.dart';

class AfterSubmissionScreen extends StatelessWidget {
  AfterSubmissionScreen(
      {Key? key, required this.hasError, this.errorMessage, this.document})
      : super(key: key);
  final bool hasError;
  final String? errorMessage;
  final DocumentForListing? document;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: hasError
                  ? _errorWidget(errorMessage!, context)
                  : _successfullySentWidget(document!, context))
        ],
      ),
    );
  }

  Widget _errorWidget(String errorMessage, BuildContext context) => Expanded(
        child: Column(
          children: [
            Lottie.asset(errorLottiePath),
            const SizedBox(
              height: 24,
            ),
            Text(
              errorMessage,
              style: txtTheme(context)
                  .headlineSmall!
                  .copyWith(color: darkRedCardBGClr),
            ),
            const SizedBox(
              height: 24,
            ),
            PurpleButtonModel(
                content: Text(
                  appTxt(context).closeCurrent,
                  style: txtTheme(context)
                      .titleMedium!
                      .copyWith(color: pureWhite, fontSize: 14),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                width: MediaQuery.of(context).size.width / 3)
          ],
        ),
      );

  Widget _successfullySentWidget(
          DocumentForListing document, BuildContext context) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(sendLottiePath),
          const SizedBox(
            height: 24,
          ),
          Text(
            appTxt(context).docSent,
            style: txtTheme(context)
                .displayMedium!
                .copyWith(color: appTheme(context).primaryColor),
          ),
          const SizedBox(
            height: 24,
          ),
          PurpleButtonModel(
              content: Text(
                appTxt(context).showDoc,
                style:
                    txtTheme(context).titleMedium!.copyWith(color: pureWhite),
              ),
              onTap: () {
                showMaterialModalBottomSheet(
                    context: context,
                    builder: (context) =>
                        DocumentPreviewScreen(document: document));
              },
              width: MediaQuery.of(context).size.width / 3),
        ],
      );
}
