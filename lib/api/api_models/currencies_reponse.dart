import 'package:etouch/businessLogic/classes/base_api_response.dart';

class CurrenciesResponse extends BaseAPIObject {
  String? code;
  CurrenciesResponse({required int? id, required String? name, required this.code})
      : super(id: id, name: name);

  factory CurrenciesResponse.fromJson(Map<String, dynamic> jsonData) {
    return CurrenciesResponse(
      id: jsonData['id'],
      name: jsonData['description'],
      code: jsonData['code'],
    );
  }
}
