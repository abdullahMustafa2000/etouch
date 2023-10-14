import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/api_models/view_product.dart';
import 'package:etouch/businessLogic/providers/create_doc_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../../../api/services.dart';
import '../../../businessLogic/classes/e_invoice_item_selection_model.dart';
import '../../../main.dart';
import '../../elements/product_creation_model.dart';
import '../../themes/themes.dart';

class ProductsSelectionWidget extends StatefulWidget {
  const ProductsSelectionWidget({
    Key? key,
    required this.loginResponse,
  }) : super(key: key);
  final LoginResponse loginResponse;
  @override
  State<ProductsSelectionWidget> createState() =>
      _ProductsSelectionWidgetState();
}

class _ProductsSelectionWidgetState extends State<ProductsSelectionWidget> {
  late PageController _controller;
  MyApiServices get service => GetIt.I<MyApiServices>();
  late EInvoiceDocProvider _docProvider;

  @override
  void initState() {
    _controller = PageController(viewportFraction: .8);
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
    _docProvider = context.read<EInvoiceDocProvider>();
    return Column(
      children: [
        AddProductWidget(
          onAddClk: () {
            _docProvider.salesOrder.productsList.add(ViewProduct.empty());
            animateTo(
                _docProvider.salesOrder.productsList.length - 1, _controller);
            setState(() {});
          },
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: FutureBuilder(
              future: _getGroups(
                  _docProvider.salesOrder.branchId,
                  _docProvider.salesOrder.warehouseId,
                  widget.loginResponse.token),
              builder: (context, AsyncSnapshot<List<BaseAPIObject>?> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snap.connectionState == ConnectionState.done &&
                      snap.hasData) {
                    return ListView.builder(
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      itemCount: _docProvider.salesOrder.productsList.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          child: ProductCreationModel(
                            index: index,
                            services: service,
                            warehouseGroups: snap.data,
                            branchId: _docProvider.salesOrder.branchId ?? -1,
                            token: widget.loginResponse.token ?? '',
                            widgetProduct:
                                _docProvider.salesOrder.productsList[index],
                            onDelete: (int index) {
                              _docProvider.salesOrder.productsList
                                  .removeAt(index);
                              _docProvider.calcDocTotalPrice();
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(appTxt(context).loginContactUsTxt),
                    );
                  }
                }
              }),
        ),
      ],
    );
  }

  Future<List<BaseAPIObject>?> _getGroups(
      int? branchId, int? warehouseId, String? token) async {
    if (branchId == null || warehouseId == null || token == null) return [];
    return (await service.getGroupsList(branchId, warehouseId, token)).data;
  }
}

class AddProductWidget extends StatelessWidget {
  const AddProductWidget({Key? key, required this.onAddClk}) : super(key: key);
  final Function onAddClk;
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
