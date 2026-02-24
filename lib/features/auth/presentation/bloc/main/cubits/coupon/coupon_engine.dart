import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/coupon_entity.dart';

class CouponResult {
  final bool isValid;
  final double discount;
  final double eligibleSubtotal;
  final double finalTotal;
  final String? error;

  const CouponResult({
    required this.isValid,
    required this.discount,
    required this.eligibleSubtotal,
    required this.finalTotal,
    this.error,
  });

  const CouponResult.invalid(String errorMsg)
      : isValid = false,
        discount = 0.0,
        eligibleSubtotal = 0.0,
        finalTotal = 0.0,
        error = errorMsg;
}

class CouponEngine {
  CouponEngine._();

  static String _baseProductId(String cartItemId) {
    return cartItemId.contains('_variant_')
        ? cartItemId.split('_variant_')[0]
        : cartItemId;
  }

  static double _itemPrice(CartEntities item) {
    if (item.variantDetails.isEmpty ||
        item.variantIndex >= item.variantDetails.length) {
      return 0.0;
    }
    final variant = item.variantDetails[item.variantIndex];
    double price = (variant['mrp'] ?? 0).toDouble();
    final discount = item.discount ?? 0;
    if (discount > 0) {
      price = price - (price * discount / 100);
    }
    return price;
  }

  static List<CartEntities> getEligibleItems(
    List<CartEntities> cartItems,
    List<String> applicableProductIds,
  ) {
    if (applicableProductIds.isEmpty) return [];
    return cartItems.where((item) {
      final baseId = _baseProductId(item.id);
      return applicableProductIds.contains(baseId);
    }).toList();
  }

  static double calculateEligibleSubtotal(List<CartEntities> eligibleItems) {
    double total = 0.0;
    for (final item in eligibleItems) {
      total += _itemPrice(item) * item.count;
    }
    return total;
  }

  static double calculateCartSubtotal(List<CartEntities> cartItems) {
    double total = 0.0;
    for (final item in cartItems) {
      total += _itemPrice(item) * item.count;
    }
    return total;
  }

  static double calculateTotalMrp(List<CartEntities> cartItems) {
    double total = 0.0;
    for (final item in cartItems) {
      if (item.variantDetails.isNotEmpty &&
          item.variantIndex < item.variantDetails.length) {
        final price =
            (item.variantDetails[item.variantIndex]['mrp'] ?? 0).toDouble();
        total += price * item.count;
      }
    }
    return total;
  }

  static String? validateCoupon(
    CouponEntity coupon,
    List<CartEntities> cartItems,
  ) {
    if (!coupon.isActive) return 'Coupon is no longer active';
    if (coupon.expiryDate.isBefore(DateTime.now())) return 'Coupon has expired';
    if (coupon.usageLimit <= 0) return 'Coupon usage limit reached';

    final eligibleItems =
        getEligibleItems(cartItems, coupon.applicableProductIds);
    if (eligibleItems.isEmpty) return 'No eligible products in cart';

    final eligibleSubtotal = calculateEligibleSubtotal(eligibleItems);
    if (eligibleSubtotal < coupon.minOrderValue) {
      return 'Minimum order value ₹${coupon.minOrderValue.toStringAsFixed(0)} not met for eligible items';
    }

    return null;
  }

  static double calculateDiscount(
    CouponEntity coupon,
    double eligibleSubtotal,
  ) {
    double discount = 0.0;
    if (coupon.percentage > 0) {
      discount = eligibleSubtotal * (coupon.percentage / 100);
    } else if (coupon.amount > 0) {
      discount = coupon.amount;
    }
    if (discount > eligibleSubtotal) discount = eligibleSubtotal;
    return discount;
  }

  static CouponResult computeResult(
    CouponEntity coupon,
    List<CartEntities> cartItems,
    double deliveryFee,
  ) {
    final validationError = validateCoupon(coupon, cartItems);
    if (validationError != null) {
      return CouponResult.invalid(validationError);
    }

    final eligibleItems =
        getEligibleItems(cartItems, coupon.applicableProductIds);
    final eligibleSubtotal = calculateEligibleSubtotal(eligibleItems);
    final cartSubtotal = calculateCartSubtotal(cartItems);
    final discount = calculateDiscount(coupon, eligibleSubtotal);
    final finalTotal = (cartSubtotal - discount) + deliveryFee;

    return CouponResult(
      isValid: true,
      discount: discount,
      eligibleSubtotal: eligibleSubtotal,
      finalTotal: finalTotal < 0 ? 0 : finalTotal,
    );
  }
}
