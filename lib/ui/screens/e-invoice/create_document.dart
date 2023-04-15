import 'package:etouch/main.dart';
import 'package:etouch/ui/elements/e_invoice_doc_taxes.dart';
import 'package:etouch/ui/elements/primary_btn_model.dart';
import 'package:etouch/ui/elements/product_creation_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';

import '../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../elements/e_invoice_document_pre_requairments_model.dart';

class CreateEInvoiceDocumentScreen extends StatelessWidget {
  CreateEInvoiceDocumentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // customers, treasury, inventory, etc...
              OrderPreRequirementsWidget(
                inventoriesList: [
                  EInvoiceDocItemSelectionModel(id: 101, name: 'Maady'),
                  EInvoiceDocItemSelectionModel(id: 102, name: 'Madent Nasr'),
                ],
                currenciesList: [
                  EInvoiceDocItemSelectionModel(id: 201, name: 'USD'),
                  EInvoiceDocItemSelectionModel(id: 202, name: 'EGP'),
                ],
                treasuriesList: [
                  EInvoiceDocItemSelectionModel(id: 301, name: 'Bank'),
                  EInvoiceDocItemSelectionModel(id: 302, name: 'Store'),
                ],
                branchesList: [
                  EInvoiceDocItemSelectionModel(id: 401, name: 'Egypt'),
                  EInvoiceDocItemSelectionModel(id: 402, name: 'Iraq'),
                ],
                customersList: [
                  EInvoiceDocItemSelectionModel(id: 501, name: 'Degla'),
                  EInvoiceDocItemSelectionModel(id: 502, name: 'Visa'),
                ],
                selectedInventory: (EInvoiceDocItemSelectionModel? val) {
                  print(val.toString());
                },
                selectedCurrency: (EInvoiceDocItemSelectionModel? val) {
                  print(val.toString());
                },
                selectedTreasury: (EInvoiceDocItemSelectionModel? val) {
                  print(val.toString());
                },
                selectedBranch: (EInvoiceDocItemSelectionModel? val) {
                  print(val.toString());
                },
                selectedCustomer: (EInvoiceDocItemSelectionModel? val) {
                  print(val.toString());
                },
              ),
              // divider,
              const SizedBox(
                height: 8,
              ),
              // add product details object
              ProductsSelectionWidget(),
              const SizedBox(
                height: 24,
              ),

              DocumentNumbers(
                taxesList: [
                  EInvoiceDocItemSelectionModel(id: 10, name: 'A'),
                  EInvoiceDocItemSelectionModel(id: 11, name: 'B'),
                ],
                selectedTax: (EInvoiceDocItemSelectionModel? val) {
                  print(val);
                },
                taxVal: EInvoiceDocItemSelectionModel(id: 12, name: 'PRODUCT'),
                totalDocPrice: 1000,
                addToPrice: true,
                paymentMethods: [
                  EInvoiceDocItemSelectionModel(id: 100, name: 'Cash'),
                  EInvoiceDocItemSelectionModel(id: 101, name: 'Visa'),
                ],
                selectedPaymentMethod: (EInvoiceDocItemSelectionModel? val) {
                  print(val);
                },
                percentDiscountOrTax: true,
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                width: double.infinity,
                child: PrimaryClrBtnModel(
                    content: Text(
                      appTxt(context).sendDocument,
                      style: txtTheme(context)
                          .titleLarge!
                          .copyWith(color: appTheme(context).primaryColorDark),
                    ),
                    onPressed: () {},
                    color: appTheme(context).primaryColor),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
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

class ProductsSelectionWidget extends StatefulWidget {
  ProductsSelectionWidget({Key? key}) : super(key: key);

  @override
  State<ProductsSelectionWidget> createState() =>
      _ProductsSelectionWidgetState();
}

class _ProductsSelectionWidgetState extends State<ProductsSelectionWidget> {
  int _noOfProducts = 1;

  late PageController _controller;
  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: .8);
  }

  void animateTo(int page, PageController controller) {
    controller.animateToPage(page,
        duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddProductWidget(
          onAddClk: () {
            setState(() {
              _noOfProducts++;
              animateTo(_noOfProducts - 1, _controller);
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: PageView.builder(
            controller: _controller,
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ProductCreationModel(
                  hasGroups: true,
                  groupsList: [
                    EInvoiceDocItemSelectionModel(name: 'Group1', id: 1),
                    EInvoiceDocItemSelectionModel(name: 'Group2', id: 2),
                  ],
                  productsList: [
                    EInvoiceDocItemSelectionModel(name: 'Product1', id: 1),
                    EInvoiceDocItemSelectionModel(name: 'Product2', id: 2),
                  ],
                  unitsList: [
                    EInvoiceDocItemSelectionModel(name: 'Meter', id: 1),
                    EInvoiceDocItemSelectionModel(name: 'Kilo', id: 2),
                  ],
                  balance: 1000,
                  productPrice: 255.5,
                  isPriceEditable: true,
                  selectedGroup: (EInvoiceDocItemSelectionModel? val) {
                    print(val.toString());
                  },
                  selectedProduct: (EInvoiceDocItemSelectionModel? val) {
                    print(val.toString());
                  },
                  selectedUnit: (EInvoiceDocItemSelectionModel? val) {
                    print(val.toString());
                  },
                  selectedQuantity: (String? val) {
                    print(val.toString());
                  },
                  selectedPrice: (String? val) {
                    print(val.toString());
                  },
                  moreThanOneItem: _noOfProducts > 1,
                  onDeleteItemClicked: () {
                    print("don't delete me please $index");
                  },
                ),
              );
            },
            scrollDirection: Axis.horizontal,
            itemCount: _noOfProducts,
          ),
        ),
      ],
    );
  }
}
