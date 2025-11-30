import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';

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



//   import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
// import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
// import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';
// /// access name from varaint details of a product
// String getName(dynamic widget) {
//     if (widget.product is ProductEntities) {
//       return (widget.product as ProductEntities).name;
//     } else if (widget.product is ExploreEntities) {
//       return (widget.product as ExploreEntities).name;
//     } else if (widget.product is WishListEntities) {
//       return (widget.product as WishListEntities).name;
//     }
//     return 'Product';
//   }

// String getDescription(dynamic widget) {
//     if (widget.product is ProductEntities) {
//       return (widget.product as ProductEntities).description ??
//           'No description available';
//     }
//     return 'No description available';
//   }

//   String getBrand(dynamic widget) {
//     if (widget.product is ProductEntities) {
//       return (widget.product as ProductEntities).brand;
//     } else if (widget.product is ExploreEntities) {
//       return (widget.product as ExploreEntities).brand;
//     }
//     return 'Brand';
//   }

//   String getId(dynamic widget) {
//     if (widget.product is ProductEntities) {
//       return (widget.product as ProductEntities).id;
//     } else if (widget.product is ExploreEntities) {
//       return (widget.product as ExploreEntities).id;
//     } else if (widget.product is WishListEntities) {
//       return (widget.product as WishListEntities).id;
//     }
//     return '';
//   }

//   List<Map<String, dynamic>> _getVariantDetails(dynamic widget) {
//     if (widget.product is ProductEntities) {
//       return (widget.product as ProductEntities).variantDetails ?? [];
//     } else if (widget.product is ExploreEntities) {
//       return (widget.product as ExploreEntities).variantDetails;
//     } else if (widget.product is WishListEntities) {
//       return (widget.product as WishListEntities).variantDetails;
//     }
//     return [];
//   }

//   List<String> getImages(dynamic widget) {
//     final variants = _getVariantDetails(widget);
//     if (variants.isEmpty || widget.variantIndex >= variants.length) return [];

//     final images = variants[widget.variantIndex]['imageUrls'] as List?;
//     if (images == null) return [];

//     return List<String>.from(images);
//   }

//   double getPrice(dynamic widget) {
//     final variants = _getVariantDetails(widget);
//     if (variants.isEmpty || widget.variantIndex >= variants.length) return 0.0;

//     final price = variants[widget.variantIndex]['mrp'] ?? 0;
//     return (price is num) ? price.toDouble() : 0.0;
//   }

//   String getVariantName(dynamic widget) {
//     final variants = _getVariantDetails(widget);
//     if (variants.isEmpty || widget.variantIndex >= variants.length) return '';

//     final unitName = variants[widget.variantIndex]['unitName'] ?? '';
//     // final unitType = variants[widget.variantIndex]['unitType'] ?? '';
//     return '$unitName';
//   }
