import 'package:rizqmart/features/domain/entities/main/show_product_entities.dart';

/// Helper method to extract the product name from a ShowProductEntities instance.
String getName(ShowProductEntities product) {
  return product.name;
}

String getVariantName(ShowProductEntities product, int variantIndex) {
  final variants = getVariantDetails(product);
  if (variants.isEmpty || variantIndex >= variants.length) return '';

  final unitName = variants[variantIndex]['unitName'] ?? '';
  return unitName;
}

String getDescription(ShowProductEntities product) {
  return product.description ?? "No description available";
}

String getBrand(ShowProductEntities product) {
  return product.brand;
}

String getId(ShowProductEntities product) {
  return product.id;
}

List<Map<String, dynamic>> getVariantDetails(ShowProductEntities product) {
  return product.variantDetails;
}

List<String> getImages(ShowProductEntities product, int variantIndex) {
  final variants = getVariantDetails(product);
  if (variants.isEmpty || variantIndex >= variants.length) return [];

  final images = variants[variantIndex]['imageUrls'] as List?;
  return images == null ? [] : List<String>.from(images);
}

double getPrice(ShowProductEntities product, int variantIndex) {
  final variants = getVariantDetails(product);
  if (variants.isEmpty || variantIndex >= variants.length) return 0.0;

  final price = variants[variantIndex]['mrp'] ?? 0;
  return (price is num) ? price.toDouble() : 0.0;
}