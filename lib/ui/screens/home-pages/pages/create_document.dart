import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/api_response.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/screens/e-invoice/e_invoice_doc_taxes.dart';
import 'package:etouch/ui/elements/primary_btn_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../../api/api_models/product_content.dart';
import '../../../../api/api_models/sales_order.dart';
import '../../../../api/api_models/tax_of_document_model.dart';
import '../../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../e-invoice/e_invoice_document_pre_requairments_model.dart';
import '../../e-invoice/products_widget.dart';

class CreateEInvoiceDocumentFragment extends StatefulWidget {
  CreateEInvoiceDocumentFragment({required this.loginResponse});
  LoginResponse loginResponse;
  @override
  State<CreateEInvoiceDocumentFragment> createState() =>
      _CreateEInvoiceDocumentFragmentState();
}

class _CreateEInvoiceDocumentFragmentState
    extends State<CreateEInvoiceDocumentFragment> {
  BaseAPIObject? selectedWarehouse,
      selectedCurrency,
      selectedTreasury,
      selectedBranch,
      selectedCustomer,
      selectedPaymentMethod;
  DocumentTaxesModel? selectedTax;
  late int orderId;
  List<BaseAPIObject>? branchesList,
      warehousesList,
      currenciesList,
      treasuriesList,
      customersList,
      paymentMethodsList;
  List<DocumentTaxesModel>? taxesList;
  List<ProductModel>? productsList;
  late Future<List<BaseAPIObject>> _currenciesFuture;
  double _totalAmountAfterTaxes = 0, _paidAmount = 0;
  late LoginResponse _userInfo;

  MyApiServices get service => GetIt.I<MyApiServices>();
  late APIResponse<List<BaseAPIObject>> _apiResponse;

  @override
  void initState() {
    _userInfo = widget.loginResponse;
    _currenciesFuture = _getCurrencies(_userInfo.companyId, _userInfo.token);
    branchesList = _userInfo.userBranches;
    orderId = 1000;
    super.initState();
  }

  late EInvoiceDocProvider documentProvider;

  @override
  Widget build(BuildContext context) {
    documentProvider = context.watch<EInvoiceDocProvider>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: _currenciesFuture,
            builder: (context, AsyncSnapshot<List<BaseAPIObject>> snap) {
              if (true) {
                initData(snap, _userInfo.token);
                return Column(
                  children: [
                    // customers, treasury, inventory, etc...
                    OrderPreRequirementsWidget(
                      inventoriesList: warehousesList,
                      currenciesList: currenciesList,
                      treasuriesList: treasuriesList,
                      branchesList: branchesList,
                      customersList: customersList,
                      selectedWarehouseFun: (BaseAPIObject? val) {
                        setState(() {
                          selectedWarehouse = val;
                        });
                      },
                      selectedCurrencyFun: (BaseAPIObject? val) {
                        setState(() {
                          selectedCurrency = val;
                        });
                      },
                      selectedTreasuryFun: (BaseAPIObject? val) {
                        setState(() {
                          selectedTreasury = val;
                        });
                      },
                      selectedBranchFun: (BaseAPIObject? val) {
                        setState(() {
                          selectedBranch = val;
                          _whenBranchSelected(val!.getId, _userInfo.token);
                        });
                      },
                      selectedCustomerFun: (BaseAPIObject? val) {
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
                      loginResponse: widget.loginResponse,
                    ),
                    const SizedBox(
                      height: 24,
                    ),

                    DocumentNumbers(
                      taxesList: taxesList,
                      selectedTaxFun:
                          (DocumentTaxesModel? val, double valAfter) {
                        setState(() {
                          selectedTax = val;
                          _totalAmountAfterTaxes = valAfter;
                        });
                      },
                      totalDocPrice: documentProvider.getTotalPrice(),
                      paymentMethods: paymentMethodsList,
                      selectedPaymentMethodFun: (BaseAPIObject? val) {
                        setState(() {
                          selectedPaymentMethod = val;
                        });
                      },
                      selectedTaxVal: selectedTax,
                      selectedPaymentMethodVal: selectedPaymentMethod,
                      paidAmountFun: (double amount) {
                        _paidAmount = amount;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),

                    //send document btn
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryClrBtnModel(
                          content: Text(
                            appTxt(context).sendDocument,
                            style: txtTheme(context).titleLarge!.copyWith(
                                color: appTheme(context).primaryColorDark),
                          ),
                          onPressed: () {
                            _submitDocument(
                                SalesOrder(
                                    branchId: selectedBranch?.getId ?? -1,
                                    treasuryId: selectedTreasury?.getId ?? -1,
                                    warehouseId: selectedWarehouse?.getId ?? -1,
                                    totalOrderAmount:
                                        documentProvider.getTotalPrice(),
                                    orderAmountAfterTaxes:
                                        _totalAmountAfterTaxes,
                                    customerId: selectedCustomer?.getId ?? -1,
                                    paid: _paidAmount,
                                    currencyId: selectedCurrency?.getId ?? -1,
                                    productsList:
                                        documentProvider.getProductsList(),
                                    orderDate: ''),
                                _userInfo.token);
                          },
                          color: appTheme(context).primaryColor),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                  ],
                );
              } else if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Center(
                  child: Text(
                    appTxt(context).checkInternetMessage,
                    style: txtTheme(context)
                        .displayLarge!
                        .copyWith(color: appTheme(context).primaryColor),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void initData(AsyncSnapshot<List<BaseAPIObject>> snap, String token) {
    currenciesList = snap.data;
    var first = branchesList!.isEmpty?null : branchesList!.first;
    selectedCustomer = customersList?.first;
    selectedWarehouse = warehousesList?.first;
    selectedCurrency = currenciesList?.first;
    selectedPaymentMethod = paymentMethodsList?.first;
    selectedBranch = first;
    _whenBranchSelected(first?.id ?? -1, token);
  }

  void updateCustomers(int branchId, String token) async {
    _apiResponse = await service.getCustomersList(branchId, token);
    customersList = _apiResponse.data;
  }

  void updateWarehouses(int branchId, String token) async {
    _apiResponse = await service.getWarehousesList(branchId, token);
    warehousesList = _apiResponse.data;
  }

  void updateTreasuries(int branchId, String token) async {
    _apiResponse = await service.getTreasuriesList(branchId, token);
    treasuriesList = _apiResponse.data;
  }

  void _startAnim() {}

  void _submitDocument(SalesOrder order, String token) async {
    if (order.branchId < 0 ||
        order.warehouseId < 0 ||
        order.currencyId < 0 ||
        order.treasuryId < 0 ||
        order.customerId < 0) {
      Fluttertoast.showToast(
          msg: appTxt(context).missingDataWarning,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: closeColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      order.orderDate = getFormattedDate(DateTime.now());
      APIResponse response = await service.postEInvoiceDocument(order, token);
      if (response.data) {
        _startAnim();
      }
    }
  }

  void _whenBranchSelected(int branchId, String token) {
    if (branchId < 0 || branchId == selectedBranch?.getId) return;
    updateCustomers(branchId, token);
    updateWarehouses(branchId, token);
    updateTreasuries(branchId, token);
    setState(() {});
  }

  Future<List<BaseAPIObject>> _getCurrencies(
      int companyId, String token) async {
    _apiResponse = await service.getCurrenciesList(companyId, token);
    return _apiResponse.data ?? [];
  }
}
