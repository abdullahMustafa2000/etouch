import 'package:etouch/api/api_models/view_product.dart';
import 'package:etouch/api/services.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:etouch/main.dart';
import 'package:etouch/ui/constants.dart';
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
  ProductCreationModel(
      {Key? key,
      required this.services,
      required this.index,
      required this.warehouseGroups,
      required this.branchId,
      required this.token,
      required this.widgetProduct,
      required this.onDelete})
      : super(key: key);
  final int index, branchId;
  final List<BaseAPIObject>? warehouseGroups;
  final MyApiServices services;
  final String token;
  final Function(int) onDelete;
  ViewProduct widgetProduct;
  @override
  State<ProductCreationModel> createState() => _ProductCreationModelState();
}

class _ProductCreationModelState extends State<ProductCreationModel> {
  late int index;
  late ScrollController _controller;
  late EInvoiceDocProvider _docProvider;
  List<BaseAPIObject>? _groups, _units;
  List<ProductModel>? _productsFromApi;
  @override
  void initState() {
    _groups = widget.warehouseGroups;
    _controller = ScrollController();
    index = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _docProvider = Provider.of<EInvoiceDocProvider>(context);
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
                child: SearchDropdownMenuModel(
                  dataList: _groups,
                  onItemSelected: (BaseAPIObject? val) {
                    _updateProducts(val, widget.branchId, widget.token);
                  },
                  selectedItem: widget.widgetProduct.groupSelected,
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

              ///sellingProductCount
              InputTypeRow(
                label: appTxt(context).quantityOfInventory,
                child: EditableInputData(
                    data: (widget.widgetProduct.quantity ?? 0).toString(),
                    hasInitValue: true,
                    onChange: (String? val, bool isEmpty) {
                      widget.widgetProduct.quantity =
                          double.parse(isEmpty ? "0" : val!);
                      _docProvider.calcDocTotalPrice();
                      //setState(() {});
                    }),
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
                          widget.widgetProduct.pieceSalePrice =
                              isEmpty ? 0 : double.parse(val!);
                          _docProvider.calcDocTotalPrice();
                          //setState(() {});
                        })
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
                    visible: _docProvider.salesOrder.productsList.length > 1,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void _updateProducts(BaseAPIObject? groupSel, int branchId, String token) {
    if (groupSel == null) return;
    _productsFromApi = [];
    _getGroupProducts(branchId, groupSel.id!, token).then((proRes) => {
          _productsFromApi = proRes,
          widget.widgetProduct.groupSelected = groupSel,
          setState(() {})
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