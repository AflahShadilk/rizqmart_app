import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/cart_entities.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/widgets/order_review_button.dart';

// ---------------- Order Product Item ----------------

class OrderProductItem extends StatelessWidget {
  // ---------------- Variables ----------------
  final CartEntities item;
  final String orderStatus;

  // ---------------- Constructor ----------------
  const OrderProductItem({super.key, required this.item, required this.orderStatus});

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    String? imageUrl;
    List<String> details = [];
    double unitPrice = 0.0;

    if (item.variantDetails.isNotEmpty && item.variantIndex < item.variantDetails.length) {
      final variant = item.variantDetails[item.variantIndex];

      final imageUrlsRaw = variant['imageUrls'];
      if (imageUrlsRaw is List) {
        final firstUrl = imageUrlsRaw
            .map((e) => e?.toString() ?? '')
            .firstWhere((e) => e.isNotEmpty, orElse: () => '');
        if (firstUrl.isNotEmpty) imageUrl = firstUrl;
      }

      final priceRaw = variant['mrp'];
      if (priceRaw != null) {
        unitPrice = (priceRaw as num).toDouble();
      }

      final unitName = variant['unitName']?.toString() ?? '';
      if (unitName.isNotEmpty) details.add(unitName);
    }

    final double totalPrice = unitPrice * item.count;
    final bool isOutForDelivery = orderStatus.toLowerCase() == 'out' || orderStatus.toLowerCase() == 'out for delivery' || orderStatus.toLowerCase() == 'delivered';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImage(
                imageUrl: imageUrl,
                width: 60,
                height: 60,
                borderRadius: BorderRadius.circular(8),
              ),
              12.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: context.ts.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    4.h,
                    if (details.isNotEmpty)
                      Text(
                        '${item.count}x  •  ${details.join(", ")}',
                        style: context.ts.bodySmall,
                      )
                    else
                      Text('${item.count}x', style: context.ts.bodySmall),
                  ],
                ),
              ),
              8.w,
              Text(
                '₹${totalPrice.toStringAsFixed(2)}',
                style: context.ts.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (isOutForDelivery) ...[
            8.h,
            Align(
              alignment: Alignment.centerRight,
              child: OrderReviewButton(item: item),
            ),
          ],
        ],
      ),
    );
  }
}
