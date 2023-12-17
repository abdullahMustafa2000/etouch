import 'package:etouch/businessLogic/classes/base_api_response.dart';

class DiscountAndTaxes extends BaseAPIObject {
  DiscountAndTaxes(int id, String name) : super(id: id, name: name);

  int? discountOrAdditionTypeId;
  bool? isPercentage;
  double? percentageOrValue;

  DiscountAndTaxes.fromJson(Map<String, dynamic> json) : super(id: json['id'], name: json['description']) {
    discountOrAdditionTypeId = json['discountOrAdditionTypeId'];
    isPercentage = json['isPercentage'];
    percentageOrValue = json['percentageOrValue'];
  }

  Map<String, dynamic> toJson() {
    return {
      "DiscountsAndTaxesId": getId,
    };
  }
}
