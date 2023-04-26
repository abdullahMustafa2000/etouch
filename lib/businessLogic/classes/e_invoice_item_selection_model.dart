import 'dart:convert';

class BaseAPIObject {
  BaseAPIObject({required this.id, required this.name});
  String name;
  int id;
  set setId(int comingId) {
    id = comingId;
  }
  int get getId => id;

  set setName(String comingName) {
    name = comingName;
  }
  String get getName => name;

  @override
  String toString() {
    return '{name: $getName, id: $getId}';
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
}