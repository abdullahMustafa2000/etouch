import 'package:etouch/api/api_models/view_product.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
import 'package:etouch/ui/elements/popups.dart';
import 'package:etouch/ui/elements/request_api_widget.dart';
import 'package:etouch/ui/elements/searchable_dropdown_model.dart';
import 'package:etouch/ui/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../api/api_models/product_content.dart';
import '../../businessLogic/classes/e_invoice_item_selection_model.dart';
import 'editable_data.dart';
import 'primary_btn_model.dart';
import 'uneditable_data.dart';

class ProductCreationModel extends StatefulWidget {
  const ProductCreationModel(
      {Key? key,
      required this.services,
      required this.index,
      required this.branchId,
      required this.token,
      required this.widgetProduct,
      required this.onDelete,
      required this.prods})
      : super(key: key);
  final int index, branchId;
  final List<ViewProduct> prods;
  final MyApiServices services;
  final String token;
  final Function(int) onDelete;
  final ViewProduct widgetProduct;
  @override
  State<ProductCreationModel> createState() => _ProductCreationModelState();
}

class _ProductCreationModelState extends State<ProductCreationModel> {
  late int index;
  int _selectedWHId = 0;
  late ScrollController _controller;
  List<BaseAPIObject>? _units, _groups;
  List<ProductModel>? _productsFromApi;
  @override
  void initState() {
    _controller = ScrollController();
    index = widget.index;
    _units = [];
    _groups = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getGroupsList(widget.branchId,
        context.read<EInvoiceDocProvider>().warehouseId, widget.token);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius:
            const BorderRadius.all(Radius.circular(cornersRadiusConst)),
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      child: Center(
        child: Scrollbar(
          thumbVisibility: true,
          controller: _controller,
          child: ListView(
            controller: _controller,
            children: [
              ///groups
              InputTypeRow(
                label: appTxt(context).groupOfInventory,
                child: Selector<EInvoiceDocProvider, int>(
                  selector: (_, provider) => provider.warehouseId,
                  builder: (_, warehouseId, __) {
                    if (_selectedWHId != warehouseId) {
                      _selectedWHId = warehouseId;
                      return RequestAPIWidget<List<BaseAPIObject>?>(
                          request: _getGroupsList(
                              widget.branchId, warehouseId, widget.token),
                          onSuccessfulResponse: (snap) {
                            _groups = snap.data;
                            return _groupsDropDown(snap.data);
                          });
                    } else {
                      return _groupsDropDown(_groups);
                    }
                  },
                ),
              ),

              ///products
              InputTypeRow(
                label: appTxt(context).productsOfInventory,
                child: SearchDropdownMenuModel(
                  dataList: _productsFromApi
                      ?.map((e) =>
                          BaseAPIObject(id: e.productId, name: e.productName))
                      .toList(),
                  onItemSelected: (BaseAPIObject? val) {
                    if (val != null) {
                      _updateSelectedProduct(val);
                      setState(() {});
                    }
                  },
                  selectedItem: BaseAPIObject(
                      id: widget.widgetProduct.productId,
                      name: widget.widgetProduct.productName),
                ),
              ),

              ///productCountInInventory
              InputTypeRow(
                label: appTxt(context).balanceOfInventory,
                child: UnEditableData(
                  data: widget.widgetProduct.productCount.toString(),
                ),
              ),

              ///quantity
              InputTypeRow(
                label: appTxt(context).quantityOfInventory,
                child: EditableInputData(
                  data: (widget.widgetProduct.quantity ?? 0).toString(),
                  hasInitValue: true,
                  onChange: (String? val, bool isEmpty) {
                    double? enteredVal = double.parse(!isEmpty ? val! : '0');
                    if (isEmpty &&
                        enteredVal > (widget.widgetProduct.productCount ?? 0)) {
                      Popups.flutterToast(
                          appTxt(context).unAcceptableCount, ToastType.error);
                    }
                    widget.widgetProduct.quantity = enteredVal;
                    context
                        .read<EInvoiceDocProvider>()
                        .updateTotalAmount(widget.prods);
                    setState(() {});
                  },
                ),
              ),

              ///productUnit
              InputTypeRow(
                label: appTxt(context).unitOfInventory,
                child: SearchDropdownMenuModel(
                  dataList: _units,
                  onItemSelected: (BaseAPIObject? val) {
                    widget.widgetProduct.unitSelected = val;
                  },
                  selectedItem: widget.widgetProduct.unitSelected,
                ),
              ),

              ///productPrice
              InputTypeRow(
                label: appTxt(context).priceOfInventory,
                child: widget.widgetProduct.isChangeable
                    ? EditableInputData(
                        data: widget.widgetProduct.pieceSalePrice.toString(),
                        hasInitValue: true,
                        onChange: (String? val, bool isEmpty) {
                          double enteredPrice =
                              double.parse(!isEmpty ? val! : '0');
                          if (isEmpty ||
                              enteredPrice < 0 ||
                              enteredPrice >
                                  (widget.widgetProduct.maxSalePrice ?? 0) ||
                              enteredPrice <
                                  (widget.widgetProduct.minSalePrice ?? 0)) {
                            Popups.flutterToast(
                                '${appTxt(context).unAcceptablePrice} ${widget.widgetProduct.maxSalePrice}',
                                ToastType.error);
                          }
                          widget.widgetProduct.pieceSalePrice = enteredPrice;
                          context
                              .read<EInvoiceDocProvider>()
                              .updateTotalAmount(widget.prods);
                          setState(() {});
                        },
                      )
                    : UnEditableData(
                        data: widget.widgetProduct.pieceSalePrice.toString()),
              ),
              Column(
                children: [
                  Text(
                    appTxt(context).totalTxt,
                    style: txtTheme(context)
                        .displaySmall!
                        .copyWith(color: appTheme(context).primaryColor),
                  ),
                  Text(
                    ((widget.widgetProduct.pieceSalePrice ?? 0) *
                            (widget.widgetProduct.quantity ?? 0))
                        .toString(),
                    style: txtTheme(context)
                        .displayLarge!
                        .copyWith(color: appTheme(context).primaryColor),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Visibility(
                    visible: widget.prods.length > 1,
                    child: PrimaryClrBtnModel(
                      content: Text(
                        appTxt(context).removeProductFromDocument,
                        style: txtTheme(context)
                            .labelLarge!
                            .copyWith(color: pureWhite),
                      ),
                      color: closeColor,
                      onPressed: () {
                        widget.onDelete(index);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _groupsDropDown(List<BaseAPIObject>? lst) {
    return SearchDropdownMenuModel(
      dataList: lst,
      onItemSelected: (BaseAPIObject? val) {
        _updateProducts(val, widget.branchId, widget.token);
        widget.widgetProduct.productId = null;
        widget.widgetProduct.productName = null;
      },
      selectedItem: widget.widgetProduct.groupSelected,
    );
  }

  void _updateProducts(BaseAPIObject? groupSel, int branchId, String token) {
    if (groupSel == null) return;
    _productsFromApi = [];
    _getGroupProducts(branchId, groupSel.id!, token).then((proRes) => {
          _productsFromApi = proRes,
          widget.widgetProduct.groupSelected = groupSel,
          setState(() {}),
        });
  }

  Future<List<ProductModel>> _getGroupProducts(
      int branchId, int groupId, String token) async {
    if (groupId < 0) return [];
    return (await widget.services
                .getProductsByGroupId(branchId, groupId, token))
            .data ??
        [];
  }

  void _updateSelectedProduct(BaseAPIObject val) {
    var cur = _productsFromApi!.firstWhere((pro) => pro.productId == val.getId);
    widget.widgetProduct.productId = cur.productId;
    widget.widgetProduct.productName = cur.productName;
    widget.widgetProduct.pieceSalePrice = cur.pieceSalePrice;
    widget.widgetProduct.maxSalePrice = cur.maxSalePrice;
    widget.widgetProduct.minSalePrice = cur.minSalePrice;
    widget.widgetProduct.productCount = cur.productCount;
    _units = [];
    _units?.add(BaseAPIObject(
        id: cur.measurementUnitsId, name: cur.measurementUnitsName));
  }

  Future<List<BaseAPIObject>?> _getGroupsList(
      int? branchId, int? warehouseId, String? token) async {
    return (await widget.services
            .getGroupsList(branchId ?? 0, warehouseId ?? 0, token ?? ''))
        .data;
  }
}

class InputTypeRow extends StatelessWidget {
  const InputTypeRow({Key? key, required this.child, required this.label})
      : super(key: key);
  final Widget child;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 56,
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 14),
            ),
          ),
          const SizedBox(
            width: 24,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
