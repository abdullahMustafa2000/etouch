import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../api/api_models/product_content.dart';
import '../../../api/api_response.dart';
import '../../../api/services.dart';
import '../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../../main.dart';
import '../../elements/product_creation_model.dart';
import '../../themes/themes.dart';

class ProductsSelectionWidget extends StatefulWidget {
  ProductsSelectionWidget({
    Key? key,
    required this.branchId,
    required this.warehouseId,
    required this.loginResponse,
  }) : super(key: key);
  int branchId, warehouseId;
  LoginResponse loginResponse;
  @override
  State<ProductsSelectionWidget> createState() =>
      _ProductsSelectionWidgetState();
}

class _ProductsSelectionWidgetState extends State<ProductsSelectionWidget> {
  late PageController _controller;
  late List<ProductModel> productsList;
  late List<BaseAPIObject>? groupsList, unitsList;
  BaseAPIObject? _selectedProduct;
  late LoginResponse _userInfo;
  MyApiServices get service => GetIt.I<MyApiServices>();
  late APIResponse<List<BaseAPIObject>> _apiResponse;
  Future<List<BaseAPIObject>> _getGroupsIfExist(
      int branchId, int warehouseId, String token) async {
    if (branchId < 0 || warehouseId < 0) return [];
    _apiResponse = await service.getGroupsList(branchId, warehouseId, token);
    return _apiResponse.data ?? [];
  }

  Future<List<ProductModel>> _getGroupProducts(int groupId, String token) async {
    if (groupId < 0) return [];
    APIResponse<List<ProductModel>> apiResponse =
        await service.getProductsByGroupId(groupId, token);
    return apiResponse.data ?? [];
  }

  Future<List<BaseAPIObject>> _getUnits(int branchId, String token) async {
    if (branchId < 0) return [];
    _apiResponse = await service.getUnitsList(branchId, token);
    return _apiResponse.data ?? [];
  }

  bool checkGroupExistence(List<BaseAPIObject>? list) {
    return list != null && list.isNotEmpty;
  }

  ProductModel emptyProduct = ProductModel(
      group: null,
      unit: null,
      balance: 0,
      productPrice: 0,
      quantity: 0,
      isDeleted: false,
      isPriceEditable: false,
      id: 0,
      name: '');

  late Future<List<BaseAPIObject>> _unitsFuture, _groupsFuture;
  int _branchId = -1, _warehouseId = -1;
  late EInvoiceDocProvider documentProvider;
  @override
  void initState() {
    productsList = [emptyProduct];
    _branchId = widget.branchId;
    _warehouseId = widget.warehouseId;
    _userInfo = widget.loginResponse;
    _controller = PageController(viewportFraction: .8);
    _unitsFuture = _getUnits(_branchId, _userInfo.token);
    _groupsFuture = _getGroupsIfExist(_branchId, _warehouseId, _userInfo.token);
    super.initState();
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
    documentProvider = context.watch<EInvoiceDocProvider>();
    return Column(
      children: [
        AddProductWidget(
          onAddClk: () {
            setState(() {
              productsList?.add(emptyProduct);
              animateTo(productsList.length - 1, _controller);
            });
          },
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: FutureBuilder(
            future: Future.wait([_unitsFuture, _groupsFuture]),
            builder: (context, AsyncSnapshot<List<List<BaseAPIObject>>> snap) {
              initData(snap, _userInfo.token);
              return ListView.builder(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: productsList.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: ProductCreationModel(
                      hasGroups: checkGroupExistence(groupsList),
                      groupsList: groupsList,
                      productsList: productsList,
                      unitsList: unitsList,
                      balance: productsList?[index].balance ?? 0,
                      productPrice: productsList?[index].productPrice ?? 0.0,
                      isPriceEditable: productsList?[index].isPriceEditable ?? false,
                      selectedGroupFun: (BaseAPIObject? val) {
                        setState(() {
                          productsList?[index].group = val;
                          _whenGroupSelected(val?.getId ?? -1, _userInfo.token);
                          documentProvider.listUpdated(productsList??[]);
                        });
                      },
                      selectedProductFun: (BaseAPIObject? val) {
                        setState(() {
                          _selectedProduct = val;
                          productsList?[index].name = val?.getName ?? '';
                          productsList?[index].id = val?.getId ?? -1;
                          documentProvider.listUpdated(productsList??[]);
                        });
                      },
                      selectedUnitFun: (BaseAPIObject? val) {
                        setState(() {
                          productsList?[index].unit = val;
                          documentProvider.listUpdated(productsList??[]);
                        });
                      },
                      selectedQuantityFun: (String? val) {
                        setState(() {
                          productsList?[index].quantity = int.parse(val!);
                          documentProvider.listUpdated(productsList??[]);
                        });
                      },
                      selectedPriceFun: (String? val) {
                        setState(() {
                          productsList?[index].productPrice = double.parse(val!);
                          documentProvider.listUpdated(productsList??[]);
                        });
                      },
                      moreThanOneItem: (productsList?.length ?? 1) > 1,
                      onDeleteItemClickedFun: () {
                        setState(() {
                          productsList!.removeAt(index);
                          documentProvider.listUpdated(productsList??[]);
                        });
                      },
                      selectedGroupVal: productsList?[index].group,
                      selectedProductVal: _selectedProduct,
                      selectedUnitVal: productsList?[index].unit,
                      selectedQuantityVal: productsList?[index].quantity ?? 0,
                      totalProductPrice: (double? price) {
                        productsList?[index].totalPrice = price ?? 0.0;
                        documentProvider.priceUpdated(productsList??[]);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void initData(AsyncSnapshot<List<List<BaseAPIObject>>> snap, String token) async {
    unitsList = snap.data?.first;
    groupsList = snap.data?[1];
  }

  void _whenGroupSelected(int groupId, String token) async {
    if (groupId < 0) return;
    productsList = await _getGroupProducts(groupId, token);
    setState(() {});
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
