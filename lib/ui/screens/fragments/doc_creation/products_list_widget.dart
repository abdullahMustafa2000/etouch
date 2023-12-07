import 'package:etouch/api/api_models/login_response.dart';
import 'package:etouch/api/api_models/sales_order.dart';
import 'package:etouch/businessLogic/classes/view_product.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../../../api/services.dart';
import '../../../../../../main.dart';
import '../../../elements/product_creation_model.dart';
import '../../../themes/themes.dart';

class ProductsSelectionWidget extends StatefulWidget {
  const ProductsSelectionWidget(
      {Key? key, required this.loginResponse, required this.salesOrder})
      : super(key: key);
  final LoginResponse loginResponse;
  final SalesOrder salesOrder;
  @override
  State<ProductsSelectionWidget> createState() =>
      _ProductsSelectionWidgetState();
}

class _ProductsSelectionWidgetState extends State<ProductsSelectionWidget> {
  late PageController _controller;
  MyApiServices get service => GetIt.I<MyApiServices>();
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
    if (widget.salesOrder.productsList.isEmpty) {
      widget.salesOrder.productsList.add(ViewProduct.empty());
    }
    return Column(
      children: [
        AddProductWidget(
          onAddClk: () {
            widget.salesOrder.productsList.add(ViewProduct.empty());
            animateTo(widget.salesOrder.productsList.length - 1, _controller);
            setState(() {});
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
            itemCount: widget.salesOrder.productsList.length,
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 1.2,
                child: ProductCreationModel(
                  salesOrder: widget.salesOrder,
                  index: index,
                  prods: widget.salesOrder.productsList,
                  services: service,
                  branchId: widget.salesOrder.branch?.getId ?? -1,
                  token: widget.loginResponse.token ?? '',
                  widgetProduct: widget.salesOrder.productsList[index],
                  onDelete: (int index) {
                    widget.salesOrder.productsList.removeAt(index);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
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
