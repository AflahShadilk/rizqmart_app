


// Get images
List<String> getVariantImages(dynamic widget) {
  List<String> imageUrls = [];
  if (widget.product.variantDetails != null && 
      widget.product.variantDetails!.isNotEmpty) {
    for (var variant in widget.product.variantDetails!) {
      final imageUrl = variant['imageUrls'] as List?;
      if (imageUrl != null) {
        imageUrls.addAll(imageUrl.whereType<String>());
      }
    }
  }
  return imageUrls;
}

// Get prices
List<double> getVariantPrices(dynamic widget) {
  List<double> prices = [];
  if (widget.product.variantDetails != null) {
    for (var variant in widget.product.variantDetails!) {
      final price = variant['price'];
      double priceValue = 0.0;
      if (price is int) {
        priceValue = price.toDouble();
      } else if (price is double) {
        priceValue = price;
      }
      prices.add(priceValue);
    }
  }
  return prices;
}

// Get Mrp
List<double> getVariantMrp(dynamic widget) {
  List<double> mrps = [];
  if (widget.product.variantDetails != null) {
    for (var variant in widget.product.variantDetails!) {
      final mrp = variant['mrp'];
      double mrpValue = 0.0;
      if (mrp is int) {
        mrpValue = mrp.toDouble();
      } else if (mrp is double) {
        mrpValue = mrp;
      }
      mrps.add(mrpValue);
    }
  }
  return mrps;
}

// Get quantities
List<int> getVariantQuantities(dynamic widget) {
  List<int> quantities = [];
  if (widget.product.variantDetails != null) {
    for (var variant in widget.product.variantDetails!) {
      quantities.add(variant['quantity'] as int? ?? 0);
    }
  }
  return quantities;
}

// Get unit names
List<String> getVariantNames(dynamic widget) {
  List<String> names = [];
  if (widget.product.variantDetails != null) {
    for (var variant in widget.product.variantDetails!) {
      names.add(variant['unitName'] as String? ?? '');
    }
  }
  return names;
}