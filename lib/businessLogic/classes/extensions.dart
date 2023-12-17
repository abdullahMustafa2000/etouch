import 'base_api_response.dart';

extension Range on double? {
  bool isBetween(double n1, double n2) {
    if (n2 < n1) {
      n2 = n1 - n2;
      n1 -= n2;
      n2 += n1;
    }
    return this! >= n1 && this! <= n2;
  }
}

extension FilterDuplicates<T extends BaseAPIObject> on List? {
  void filterDuplicates() {
    Map<int, String> map = {};
    for (var item in this as List<T>) {
      map[item.getId] = item.getName;
    }
    this?.clear();
    map.forEach((key, value) {
      this?.add(BaseAPIObject(id: key, name: value) as T);
    });
  }
}