import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';

class ProductModel extends EInvoiceDocItemSelectionModel {
  EInvoiceDocItemSelectionModel? group;
  EInvoiceDocItemSelectionModel? product, unit;
  int? balance, quantity;
  double? price;
  bool isDeleted;
  ProductModel(this.group, this.product, this.unit, this.balance, this.quantity,
      this.price, this.isDeleted, int id, String name) : super(id: id, name: name);

  @override
  String toString() {
    return 'group = $group, product = $product, unit = $unit, balance = $balance, quantity = $quantity, price = $price, isDeleted = $isDeleted';
  }
}
