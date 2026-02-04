abstract class ShowProductEntities {
  String get id;
  String get name;
  String get brand;
  String? get description;
  List<Map<String,dynamic>> get variantDetails;
  double? get discount;
}