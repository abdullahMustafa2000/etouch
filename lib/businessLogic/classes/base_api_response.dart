import 'dart:convert';

class BaseAPIObject {
  BaseAPIObject({required this.id, required this.name});
  String? name;
  int? id;
  set setId(int comingId) {
    id = comingId;
  }

  String get getName => name ?? '';

  int get getId => id ?? -1;

  @override
  String toString() {
    return '{name: $name, id: $id}';
  }

  factory BaseAPIObject.fromJson(Map<String, dynamic> jsonData) {
    return BaseAPIObject(
      id: jsonData['id'],
      name: jsonData['description'],
    );
  }

  static Map<String, dynamic> toMap(BaseAPIObject obj) => {
    'id': obj.id,
    'description': obj.name,
  };

  static String encode(List<BaseAPIObject> responseList) => json.encode(
    responseList
        .map<Map<String, dynamic>>((obj) => BaseAPIObject.toMap(obj))
        .toList(),
  );

  static List<BaseAPIObject> decode(String responses) =>
      (json.decode(responses) as List<dynamic>)
          .map<BaseAPIObject>((item) => BaseAPIObject.fromJson(item))
          .toList();

  Map<String, dynamic> toJson({required String keyName, required String valueName, required double value}) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[keyName] = getId;
    data[valueName] = value;
    return data;
  }
}