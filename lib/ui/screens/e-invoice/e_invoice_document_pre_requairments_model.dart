import 'package:etouch/ui/elements/dropdown_model.dart';
import 'package:flutter/material.dart';

import '../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../../main.dart';
import '../../constants.dart';
import '../../themes/themes.dart';

class OrderPreRequirementsWidget extends StatelessWidget {
  OrderPreRequirementsWidget(
      {Key? key,
      required this.inventoriesList,
      required this.currenciesList,
      required this.treasuriesList,
      required this.branchesList,
      required this.customersList,
      required this.selectedWarehouseFun,
      required this.selectedCurrencyFun,
      required this.selectedTreasuryFun,
      required this.selectedBranchFun,
      required this.selectedCustomerFun,
      required this.orderNumber,
      required this.selectedBranch,
      required this.selectedWarehouse,
      required this.selectedCurrency,
      required this.selectedTreasury,
      required this.selectedCustomer})
      : super(key: key);
  List<BaseAPIObject>? branchesList,
      inventoriesList,
      currenciesList,
      treasuriesList,
      customersList;
  Function selectedBranchFun,
      selectedWarehouseFun,
      selectedCurrencyFun,
      selectedTreasuryFun,
      selectedCustomerFun;
  int orderNumber;
  BaseAPIObject? selectedCustomer,
      selectedBranch,
      selectedCurrency,
      selectedTreasury,
      selectedWarehouse;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
            dataList1: branchesList,
            label2: appTxt(context).inventoryTxt,
            dataList2: inventoriesList,
            selectedVal1: (BaseAPIObject? val1) {
              selectedBranchFun(val1);
            },
            selectedVal2: (BaseAPIObject? val2) {
              selectedWarehouseFun(val2);
            },
            selectedItem1: selectedBranch,
            selectedItem2: selectedWarehouse,
          ),
          const SizedBox(
            height: 24,
          ),
          PreRequirementsRow(
            label1: appTxt(context).currencyTxt,
            dataList1: currenciesList,
            label2: appTxt(context).treasuryTxt,
            dataList2: treasuriesList,
            selectedVal1: (BaseAPIObject? val1) {
              selectedCurrencyFun(val1);
            },
            selectedVal2: (BaseAPIObject? val2) {
              selectedTreasuryFun(val2);
            },
            selectedItem1: selectedCurrency,
            selectedItem2: selectedTreasury,
          ),
          const SizedBox(
            height: 24,
          ),
          RequiredInfoDesign(
            label: appTxt(context).customerTxt,
            dataList: customersList,
            selectedVal: (BaseAPIObject? val) {
              selectedCustomerFun(val);
            },
            selectedItem: selectedCustomer,
          ),
          const SizedBox(
            height: 18,
          ),
          Container(
            width: double.infinity,
            height: 1,
            color: pureWhite,
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${appTxt(context).dateTxt}:',
                    style: txtTheme(context)
                        .labelLarge!
                        .copyWith(color: pureWhite),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    '${appTxt(context).orderNumTxt}:',
                    style: txtTheme(context)
                        .labelLarge!
                        .copyWith(color: pureWhite),
                  ),
                ],
              ),
              const SizedBox(
                width: 24,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateTime.now().toString(),
                    style: txtTheme(context)
                        .labelMedium!
                        .copyWith(color: pureWhite),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    orderNumber.toString(),
                    style: txtTheme(context)
                        .labelMedium!
                        .copyWith(color: pureWhite),
                  ),
                ],
              ),
            ],
          )
        ],
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
      required this.dataList2,
      required this.selectedVal1,
      required this.selectedVal2,
      required this.selectedItem1,
      required this.selectedItem2})
      : super(key: key);
  String label1, label2;
  List<BaseAPIObject>? dataList1, dataList2;
  Function selectedVal1, selectedVal2;
  BaseAPIObject? selectedItem1, selectedItem2;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: RequiredInfoDesign(
            label: label1,
            dataList: dataList1,
            selectedVal: (BaseAPIObject? val) {
              selectedVal1(val);
            },
            selectedItem: selectedItem1,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: RequiredInfoDesign(
            label: label2,
            dataList: dataList2,
            selectedVal: (BaseAPIObject? val) {
              selectedVal2(val);
            },
            selectedItem: selectedItem2,
          ),
        ),
      ],
    );
  }
}

class RequiredInfoDesign extends StatelessWidget {
  RequiredInfoDesign(
      {Key? key,
      required this.label,
      required this.dataList,
      required this.selectedVal,
      required this.selectedItem})
      : super(key: key);
  String label;
  List<BaseAPIObject>? dataList;
  Function selectedVal;
  BaseAPIObject? selectedItem;
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
            defValue: dataList != null && dataList!.isNotEmpty?dataList!.first:null,
            dataList: dataList,
            selectedVal: (BaseAPIObject? val) {
              selectedVal(val);
            }, /*AppLocalizations.of(context)!.chooseFromDropDownTxt*/
          ),
        ),
      ],
    );
  }
}
