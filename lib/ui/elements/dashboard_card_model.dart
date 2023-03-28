// ignore_for_file: must_be_immutable
import 'dart:ffi';

import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardCard extends StatelessWidget {
  DashboardCard(
      {Key? key,
      required this.cardTitle,
      required this.cardColor,
      required this.titleColor,
      required this.dataColor,
      required this.progressColor,
      required this.numOfDocuments,
      required this.total,
      required this.taxes,
      required this.progressWidth,
      required this.cardIcon})
      : super(key: key);
  String cardTitle;
  Color titleColor;
  Color progressColor;
  Color cardColor;
  Color dataColor;
  String cardIcon;
  double progressWidth;
  int numOfDocuments;
  double total;
  double taxes;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width * .6,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius:
                  const BorderRadius.all(Radius.circular(cornersRadiusConst)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$cardTitle ($numOfDocuments)',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: titleColor),
                  ),
                  CardDataRow(
                    total: total,
                    taxes: taxes,
                    txtColor: dataColor,
                    cardIcon: cardIcon,
                  ),
                  ProgressBar(
                      width: progressWidth,
                      foregroundColor: titleColor,
                      backgroundColor: progressColor),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardDataRow extends StatelessWidget {
  CardDataRow(
      {Key? key,
      required this.total,
      required this.taxes,
      required this.txtColor,
      required this.cardIcon})
      : super(key: key);
  double total;
  double taxes;
  Color txtColor;
  String cardIcon;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${AppLocalizations.of(context)!.totalTxt} : $total',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: txtColor),
            ),
            const SizedBox(
              height: 12,
            ),
            Text('${AppLocalizations.of(context)!.taxesTxt} : $taxes',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: txtColor)),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(cardIcon),
          ],
        ),
      ],
    );
  }
}

class ProgressBar extends StatelessWidget {
  ProgressBar(
      {required this.width,
      required this.foregroundColor,
      required this.backgroundColor});
  double width;
  Color foregroundColor, backgroundColor;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RoundedLine(
          color: backgroundColor,
          width: double.infinity,
        ),
        RoundedLine(
          color: foregroundColor,
          width: width,
        ),
      ],
    );
  }
}

class RoundedLine extends StatelessWidget {
  Color color;
  double? width;
  RoundedLine({this.width, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(cardLineRadius)),
      ),
    );
  }
}
