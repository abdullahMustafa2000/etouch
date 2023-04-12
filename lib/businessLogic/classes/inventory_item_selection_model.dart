class InventoryItemSelectionModel {
  InventoryItemSelectionModel({required this.id, required this.name});
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
}