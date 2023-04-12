import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/dropdown_model.dart';
import 'package:etouch/ui/elements/product_creation_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

import '../../../businessLogic/classes/inventory_item_selection_model.dart';

class CreateEInvoiceDocumentScreen extends StatefulWidget {
  CreateEInvoiceDocumentScreen({Key? key}) : super(key: key);

  @override
  State<CreateEInvoiceDocumentScreen> createState() =>
      _CreateEInvoiceDocumentScreenState();
}

class _CreateEInvoiceDocumentScreenState
    extends State<CreateEInvoiceDocumentScreen> {
  int _noOfProducts = 1;
  late PageController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: .8);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // customers, treasury, inventory, etc...
            const OrderPreRequirementsWidget(),
            // divider,
            const SizedBox(
              height: 6,
            ),
            // add product details object
            AddProductWidget(
              onAddClk: () {
                setState(() {
                  _noOfProducts++;
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: PageView.builder(
                controller: _controller,
                itemBuilder: (context, index) {
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ProductCreationModel(
                        groupsList: [
                          InventoryItemSelectionModel(name: 'Group1', id: 1),
                          InventoryItemSelectionModel(name: 'Group2', id: 2),
                        ],
                        productsList: [
                          InventoryItemSelectionModel(name: 'Product1', id: 1),
                          InventoryItemSelectionModel(name: 'Product2', id: 2),
                        ],
                        unitsList: [
                          InventoryItemSelectionModel(name: 'Meter', id: 1),
                          InventoryItemSelectionModel(name: 'Kilo', id: 2),
                        ],
                        balance: 1000,
                        price: 255.5,
                        isPriceEditable: true,
                        selectedGroup: (InventoryItemSelectionModel? val) {
                          print(val.toString());
                        },
                        selectedProduct: (InventoryItemSelectionModel? val) {
                          print(val.toString());
                        },
                        selectedUnit: (InventoryItemSelectionModel? val) {
                          print(val.toString());
                        },
                        selectedQuantity: (String? val) {
                          print(val.toString());
                        },
                        selectedPrice: (String? val) {
                          print(val.toString());
                        },
                      ));
                },
                scrollDirection: Axis.horizontal,
                itemCount: _noOfProducts,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderPreRequirementsWidget extends StatelessWidget {
  const OrderPreRequirementsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RequiredInfoDesign(
            label: appTxt(context).customerTxt, dataList: const ['EGP', 'USD']),
      ],
    );
  }
}

class AddProductWidget extends StatelessWidget {
  AddProductWidget({Key? key, required this.onAddClk}) : super(key: key);
  Function onAddClk;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onAddClk();
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: secondaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                Icons.add,
                color: pureWhite,
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            appTxt(context).addProductToDocument,
            style: txtTheme(context)
                .titleMedium!
                .copyWith(color: appTheme(context).primaryColor),
          ),
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
