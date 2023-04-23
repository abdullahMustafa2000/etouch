import 'package:etouch/businessLogic/classes/e_invoice_item_selection_model.dart';

class DocumentTaxesModel extends BaseAPIObject {
  DocumentTaxesModel(
      {required this.valueOfTax,
      required this.addToPrice,
      required this.fixedValue,
      required int id,
      required String name})
      : super(id: id, name: name);
  bool addToPrice, fixedValue;
  double valueOfTax;
}
