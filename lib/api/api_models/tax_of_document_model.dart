import 'package:etouch/businessLogic/classes/base_api_response.dart';

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
