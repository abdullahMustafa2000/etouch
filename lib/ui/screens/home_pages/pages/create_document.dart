import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/api_response.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/classes/document_for_listing.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/elements/purple_btn.dart';
import 'package:etouch/ui/screens/after_submission_screen.dart';
import 'package:etouch/ui/screens/e-invoice/e_invoice_doc_taxes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../../api/api_models/product_content.dart';
import '../../../../api/api_models/sales_order.dart';
import '../../../../api/api_models/tax_of_document_model.dart';
import '../../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../e-invoice/e_invoice_document_pre_requairments_model.dart';
import '../../e-invoice/products_widget.dart';

class CreateEInvoiceDocumentFragment extends StatefulWidget {
  const CreateEInvoiceDocumentFragment({Key? key, required this.loginResponse})
      : super(key: key);
  final LoginResponse loginResponse;
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
  int? orderId;
  List<BaseAPIObject>? branchesList,
      warehousesList,
      currenciesList,
      treasuriesList,
      customersList,
      paymentMethodsList;
  List<DocumentTaxesModel>? taxesList;
  List<ProductModel>? productsList;
  late Future<bool> _branchData;
  double _totalAmountAfterTaxes = 0, _paidAmount = 0;
  late LoginResponse _userInfo;
  MyApiServices get service => GetIt.I<MyApiServices>();
  late APIResponse<List<BaseAPIObject>> _apiResponse;

  @override
  void initState() {
    _userInfo = widget.loginResponse;
    branchesList = _userInfo.userBranches;
    _branchData = _whenBranchSelected(
        branchesList?[0].id ?? 0, _userInfo.companyId ?? -1, _userInfo.token!);
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
          child: FutureBuilder<bool>(
            future: _branchData,
            builder: (context, AsyncSnapshot<bool> snap) {
              if (snap.connectionState == ConnectionState.done &&
                  snap.hasData) {
                initData(_userInfo.token!);
                return Column(
                  children: [
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
                          _whenBranchSelected(val!.getId,
                              _userInfo.companyId ?? 0, _userInfo.token!);
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
                      branchId: selectedBranch?.getId ?? 94,
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
                      child: PurpleButtonModel(
                        content: Text(
                          appTxt(context).sendDocument,
                          style: txtTheme(context).titleLarge!.copyWith(
                              color: appTheme(context).primaryColorDark),
                        ),
                        onTap: () {
                          _submitDocument(
                              SalesOrder(
                                branchId: selectedBranch?.getId ?? -1,
                                treasuryId: selectedTreasury?.getId ?? -1,
                                warehouseId: selectedWarehouse?.getId ?? -1,
                                totalOrderAmount:
                                    documentProvider.getTotalPrice(),
                                orderAmountAfterTaxes: _totalAmountAfterTaxes,
                                customerId: selectedCustomer?.getId ?? -1,
                                paid: _paidAmount,
                                currencyId: selectedCurrency?.getId ?? -1,
                                productsList:
                                    documentProvider.getProductsList(),
                                orderDate: getFormattedDate(DateTime.now()),
                              ),
                              _userInfo.token!);
                        },
                        width: double.infinity,
                      ),
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

  void initData(String token) {
    var first = branchesList!.isEmpty ? null : branchesList!.first;
    selectedCustomer = customersList?.first;
    selectedWarehouse = warehousesList?.first;
    selectedCurrency = currenciesList?.first;
    selectedPaymentMethod = paymentMethodsList?.first;
    selectedBranch = first;
    _whenBranchSelected(
        _userInfo.userBranches?.first.id ?? -1, _userInfo.companyId ?? 0, token);
  }

  Future<bool> updateCustomers(int branchId, String token) async {
    _apiResponse = await service.getCustomersList(branchId, token);
    customersList = _apiResponse.data;
    return customersList != null;
  }

  Future<bool> updateWarehouses(int branchId, String token) async {
    _apiResponse = await service.getWarehousesList(branchId, token);
    warehousesList = _apiResponse.data;
    return warehousesList != null;
  }

  Future<bool> updateTreasuries(int branchId, String token) async {
    _apiResponse = await service.getTreasuriesList(branchId, token);
    treasuriesList = _apiResponse.data;
    return treasuriesList != null;
  }

  void _submitDocument(SalesOrder order, String token) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AfterSubmissionScreen(
          hasError: false,
          document: DocumentForListing(
              type: 'Purchases',
              id: 1,
              registrationId: 12,
              ownerName: 'Hesham',
              submissionDate: DateTime.now(),
              totalAmount: 12000,
              status: 'valid'),
          errorMessage: 'not sending because...',
        ),
      ),
    );
  }

  Future<bool> _whenBranchSelected(
      int branchId, int companyId, String token) async {
    bool customers = await updateCustomers(branchId, token);
    bool warehouses = await updateWarehouses(branchId, token);
    bool treasuries = await updateTreasuries(branchId, token);
    bool currencies = await _getCurrencies(companyId, token);
    bool paymentMethods = await _getPaymentMethods(companyId, token);
    return customers &&
        warehouses &&
        treasuries &&
        currencies &&
        paymentMethods;
  }

  Future<bool> _getCurrencies(int companyId, String token) async {
    _apiResponse = await service.getCurrenciesList(companyId, token);
    currenciesList = _apiResponse.data;
    return currenciesList != null;
  }

  Future<bool> _getPaymentMethods(int companyId, String token) async {
    _apiResponse = await service.getPaymentMethodsList(companyId, token);
    paymentMethodsList = _apiResponse.data;
    return paymentMethodsList != null;
  }
}
