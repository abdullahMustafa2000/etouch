import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';

class ProductModel extends BaseAPIObject {
  BaseAPIObject? group;
  BaseAPIObject? unit;
  int? balance, quantity;
  double? productPrice, totalPrice;
  bool isDeleted, isPriceEditable;
  ProductModel(
      {required this.group,
      required this.unit,
      required this.balance,
      this.quantity,
      required this.productPrice,
      required this.isDeleted,
      required this.isPriceEditable,
      required int id,
      required String name}) : super(id: id, name: name);

  @override
  String toString() {
    return 'group = $group, unit = $unit, balance = $balance, quantity = $quantity, price = $productPrice, isDeleted = $isDeleted';
  }
}
