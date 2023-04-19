import 'package:etouch/main.dart';
import 'package:etouch/ui/elements/e_invoice_doc_taxes.dart';
import 'package:etouch/ui/elements/primary_btn_model.dart';
import 'package:etouch/ui/elements/product_creation_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import '../../../businessLogic/classes/api_models/product_content.dart';
import '../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../elements/e_invoice_document_pre_requairments_model.dart';

class CreateEInvoiceDocumentScreen extends StatefulWidget {
  CreateEInvoiceDocumentScreen({Key? key}) : super(key: key);

  @override
  State<CreateEInvoiceDocumentScreen> createState() => _CreateEInvoiceDocumentScreenState();
}

class _CreateEInvoiceDocumentScreenState extends State<CreateEInvoiceDocumentScreen> {
  EInvoiceDocItemSelectionModel? selectedWarehouse,
      selectedCurrency,
      selectedTreasury,
      selectedBranch,
      selectedCustomer, selectedTax, selectedPaymentMethod;
  late int orderId;
  List<EInvoiceDocItemSelectionModel>? branchesList,
      warehousesList,
      currenciesList,
      treasuriesList,
      customersList,
      paymentMethodsList,
      taxesList;

  @override
  void initState() {
    super.initState();
    branchesList = [
      EInvoiceDocItemSelectionModel(id: 1, name: 'Branch1'),
      EInvoiceDocItemSelectionModel(id: 2, name: 'Branch2'),
      EInvoiceDocItemSelectionModel(id: 3, name: 'Branch3'),
    ];
    warehousesList = [
      EInvoiceDocItemSelectionModel(id: 1, name: 'Warehouse1'),
      EInvoiceDocItemSelectionModel(id: 2, name: 'Warehouse2'),
      EInvoiceDocItemSelectionModel(id: 3, name: 'Warehouse3'),
    ];
    currenciesList = [
      EInvoiceDocItemSelectionModel(id: 1, name: 'Currency1'),
      EInvoiceDocItemSelectionModel(id: 2, name: 'Currency2'),
      EInvoiceDocItemSelectionModel(id: 3, name: 'Currency3'),
    ];
    treasuriesList = [
      EInvoiceDocItemSelectionModel(id: 1, name: 'Treasury1'),
      EInvoiceDocItemSelectionModel(id: 2, name: 'Treasury2'),
      EInvoiceDocItemSelectionModel(id: 3, name: 'Treasury3'),
    ];
    customersList = [
      EInvoiceDocItemSelectionModel(id: 1, name: 'Customer1'),
      EInvoiceDocItemSelectionModel(id: 2, name: 'Customer2'),
      EInvoiceDocItemSelectionModel(id: 3, name: 'Customer3'),
    ];
    paymentMethodsList = [
      EInvoiceDocItemSelectionModel(id: 1, name: 'Payment1'),
      EInvoiceDocItemSelectionModel(id: 2, name: 'Payment2'),
      EInvoiceDocItemSelectionModel(id: 3, name: 'Payment3'),
    ];
    taxesList = [
      EInvoiceDocItemSelectionModel(id: 1, name: 'Tax1'),
      EInvoiceDocItemSelectionModel(id: 2, name: 'Tax2'),
      EInvoiceDocItemSelectionModel(id: 3, name: 'Tax3'),
    ];
    orderId = 1000;
  }

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
                inventoriesList: warehousesList,
                currenciesList: currenciesList,
                treasuriesList: treasuriesList,
                branchesList: branchesList,
                customersList: customersList,
                selectedWarehouseFun: (EInvoiceDocItemSelectionModel? val) {
                  setState(() {
                    selectedWarehouse = val;
                  });
                },
                selectedCurrencyFun: (EInvoiceDocItemSelectionModel? val) {
                  setState(() {
                    selectedCurrency = val;
                  });
                },
                selectedTreasuryFun: (EInvoiceDocItemSelectionModel? val) {
                  setState(() {
                    selectedTreasury = val;
                  });
                },
                selectedBranchFun: (EInvoiceDocItemSelectionModel? val) {
                  setState(() {
                    selectedBranch = val;
                  });
                },
                selectedCustomerFun: (EInvoiceDocItemSelectionModel? val) {
                  setState(() {
                    selectedCustomer = val;
                  });
                },
                selectedCustomer: selectedCustomer,
                selectedBranch: selectedBranch,
                selectedCurrency: selectedCurrency,
                selectedTreasury: selectedTreasury,
                selectedWarehouse: selectedWarehouse,
                orderNumber: orderId,
              ),
              // divider,

              const SizedBox(
                height: 8,
              ),
              // add product details object
              ProductsSelectionWidget(
                branchId: selectedBranch?.getId ?? -1,
                warehouseId: selectedWarehouse?.getId ?? -1,
              ),
              const SizedBox(
                height: 24,
              ),

              DocumentNumbers(
                taxesList: taxesList,
                selectedTax: (EInvoiceDocItemSelectionModel? val) {
                  setState(() {
                    selectedTax = val;
                  });
                },
                taxVal: EInvoiceDocItemSelectionModel(id: 12, name: 'PRODUCT'),
                totalDocPrice: 1000,
                addToPrice: true,
                paymentMethods: paymentMethodsList,
                selectedPaymentMethod: (EInvoiceDocItemSelectionModel? val) {
                  setState(() {
                    selectedPaymentMethod = val;
                  });
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
  ProductsSelectionWidget({Key? key, required this.branchId, required this.warehouseId}) : super(key: key);
  int? branchId, warehouseId;
  @override
  State<ProductsSelectionWidget> createState() =>
      _ProductsSelectionWidgetState();
}

class _ProductsSelectionWidgetState extends State<ProductsSelectionWidget> {
  late PageController _controller;
  late List<ProductModel> productsList;
  int _counter = 1;
  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: .8);
    productsList = [
      ProductModel(
          EInvoiceDocItemSelectionModel(name: 'Group1', id: 1),
          EInvoiceDocItemSelectionModel(name: 'Product1', id: 1),
          EInvoiceDocItemSelectionModel(name: 'Meter', id: 1),
          10,
          20,
          100,
          false),
      ProductModel(
          EInvoiceDocItemSelectionModel(name: 'Group2', id: 2),
          EInvoiceDocItemSelectionModel(name: 'Product2', id: 2),
          EInvoiceDocItemSelectionModel(name: 'Kilo', id: 2),
          100,
          200,
          1000,
          true),
      ProductModel(
          EInvoiceDocItemSelectionModel(name: 'Group1', id: 1),
          EInvoiceDocItemSelectionModel(name: 'Product1', id: 1),
          EInvoiceDocItemSelectionModel(name: 'Meter', id: 1),
          1000,
          2000,
          10000,
          false),
    ];
    _counter = productsList.length - 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              _counter++;
              productsList
                  .add(ProductModel(null, null, null, null, null, null, false));
              animateTo(_counter - 1, _controller);
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: ListView.builder(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            itemCount: productsList.length,
            itemBuilder: (context, index) {
              return productsList[index].isDeleted
                  ? SizedBox()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: ProductCreationModel(
                        hasGroups: true,
                        groupsList: [
                          EInvoiceDocItemSelectionModel(name: 'Group1', id: 1),
                          EInvoiceDocItemSelectionModel(name: 'Group2', id: 2),
                          EInvoiceDocItemSelectionModel(name: 'Group3', id: 3),
                        ],
                        productsList: [
                          EInvoiceDocItemSelectionModel(
                              name: 'Product1', id: 1),
                          EInvoiceDocItemSelectionModel(
                              name: 'Product2', id: 2),
                          EInvoiceDocItemSelectionModel(
                              name: 'Product3', id: 3),
                        ],
                        unitsList: [
                          EInvoiceDocItemSelectionModel(name: 'Meter', id: 1),
                          EInvoiceDocItemSelectionModel(name: 'Kilo', id: 2),
                          EInvoiceDocItemSelectionModel(name: 'Milli', id: 3),
                        ],
                        balance: productsList[index].balance ?? 0,
                        productPrice: productsList[index].price ?? 0.0,
                        isPriceEditable: true,
                        selectedGroupFun: (EInvoiceDocItemSelectionModel? val) {
                          setState(() {
                            productsList[index].group = val;
                          });
                        },
                        selectedProductFun:
                            (EInvoiceDocItemSelectionModel? val) {
                          setState(() {
                            productsList[index].product = val;
                          });
                        },
                        selectedUnitFun: (EInvoiceDocItemSelectionModel? val) {
                          setState(() {
                            productsList[index].unit = val;
                          });
                        },
                        selectedQuantityFun: (String? val) {
                          setState(() {
                            productsList[index].quantity = int.parse(val!);
                          });
                        },
                        selectedPriceFun: (String? val) {
                          setState(() {
                            productsList[index].price = double.parse(val!);
                          });
                        },
                        moreThanOneItem: _counter > 1,
                        onDeleteItemClickedFun: () {
                          setState(() {
                            productsList[index].isDeleted = true;
                            _counter--;
                          });
                        },
                        selectedGroupVal: productsList[index].group,
                        selectedProductVal: productsList[index].product,
                        selectedUnitVal: productsList[index].unit,
                        selectedQuantityVal: productsList[index].quantity ?? 0,
                      ),
                    );
            },
          ),
        ),
      ],
    );
  }
}
