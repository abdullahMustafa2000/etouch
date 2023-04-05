import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dropdown-model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

class CreateEInvoiceDocumentScreen extends StatelessWidget {
  const CreateEInvoiceDocumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          OrderPreRequirementsWidget(),
        ],
      ),
    );
  }
}

class OrderPreRequirementsWidget extends StatelessWidget {
  const OrderPreRequirementsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(cornersRadiusConst)),
        gradient: LinearGradient(
            colors: [accentColor, primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Column(
        children: [
          Text(
            appTxt(context).createDocumentTitle,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: pureWhite),
          ),
          const SizedBox(
            height: 24,
          ),
          PreRequirementsRow(
              label1: appTxt(context).branchTxt,
              dataList1: const ['maady', 'dokky'],
              label2: appTxt(context).inventoryTxt,
              dataList2: const ['mohad', 'mostafa']),
          const SizedBox(
            height: 24,
          ),
          PreRequirementsRow(
              label1: appTxt(context).currencyTxt,
              dataList1: const ['aadfsfadaaafdadfadfdafdfafsdafda', 'fddsrag'],
              label2: appTxt(context).treasuryTxt,
              dataList2: const ['tawheed', 'welnoor']),
          const SizedBox(
            height: 24,
          ),
          CurrencyAndSendToETSRow(),
        ],
      ),
    );
  }
}

class CurrencyAndSendToETSRow extends StatelessWidget {
  const CurrencyAndSendToETSRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: RequiredInfoDesign(
              label: appTxt(context).customerTxt,
              dataList: const ['EGP', 'USD']),
        ),
      ],
    );
  }
}

class MyCheckBox extends StatefulWidget {
  MyCheckBox({Key? key}) : super(key: key);

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  bool _isON = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isON = !_isON;
        });
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: _isON ? primaryColor : pureWhite,
          borderRadius:
              const BorderRadius.all(Radius.circular(cornersRadiusConst)),
        ),
        child: _isON
            ? Icon(
                Icons.check,
                color: pureWhite,
              )
            : null,
      ),
    );
  }
}

class PreRequirementsRow extends StatelessWidget {
  PreRequirementsRow(
      {Key? key,
      required this.label1,
      required this.dataList1,
      required this.label2,
      required this.dataList2})
      : super(key: key);
  String label1, label2;
  List<String> dataList1, dataList2;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: RequiredInfoDesign(label: label1, dataList: dataList1)),
        const SizedBox(
          width: 8,
        ),
        Expanded(child: RequiredInfoDesign(label: label2, dataList: dataList2)),
      ],
    );
  }
}

class RequiredInfoDesign extends StatelessWidget {
  RequiredInfoDesign({Key? key, required this.label, required this.dataList})
      : super(key: key);
  String label;
  List<String> dataList;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: const Color.fromRGBO(218, 198, 248, 1)),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: DropDownMenuModel(
            dataList: dataList,
            defValue: dataList
                .first, /*AppLocalizations.of(context)!.chooseFromDropDownTxt*/
          ),
        ),
      ],
    );
  }
}
