




import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';

List<String> getVariantImages(ShowProductEntities product) {
  List<String> imageUrls = [];

  for (var variant in product.variantDetails) {
    final imageUrl = variant['imageUrls'] as List?;
    if (imageUrl != null) {
      imageUrls.addAll(imageUrl.whereType<String>());
    }
  }

  return imageUrls;
}


List<double> getVariantPrices(ProductEntities product) {
  List<double> prices = [];
  
  for (var variant in product.variantDetails) {
    final price = variant['price'];
    double priceValue = 0.0;
    if (price is int) {
      priceValue = price.toDouble();
    } else if (price is double) {
      priceValue = price;
    }
    prices.add(priceValue);
  }
  return prices;
}

List<double> getVariantMrp(ProductEntities product) {
  List<double> mrps = [];
  
  for (var variant in product.variantDetails) {
    final mrp = variant['mrp'];
    double mrpValue = 0.0;
    if (mrp is int) {
      mrpValue = mrp.toDouble();
    } else if (mrp is double) {
      mrpValue = mrp;
    }
    mrps.add(mrpValue);
  }
  return mrps;
}


List<int> getVariantQuantities(ProductEntities product) {
  List<int> quantities = [];
  
  for (var variant in product.variantDetails) {
    quantities.add(variant['quantity'] as int? ?? 0);
  }
  return quantities;
}


List<String> getVariantNames(ProductEntities product) {
  List<String> names = [];
  
  for (var variant in product.variantDetails) {
    names.add(variant['unitName'] as String? ?? '');
  }
  return names;
}