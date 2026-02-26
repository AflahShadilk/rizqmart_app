

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
import 'package:rizqmart/core/services/firestore_product/variant_det_getter.dart';
/// Returns a dropdown overlay widget populated with search result suggestions to preview and select products.
Widget searchResultsDropdown({
  required BuildContext context,
  required TextEditingController controller,
  required List<ShowProductEntities> items,
  required VoidCallback onProductSelected,
}) {
  final cs = Theme.of(context).colorScheme;

  return Material(
    elevation: 8,
    borderRadius: BorderRadius.circular(12),
    color: cs.surface,
    child: Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.3,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: cs.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 40, bottom: 8),
            itemCount: items.length > 5 ? 5 : items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: cs.onSurface.withValues(alpha: 0.1),
              indent: 12,
              endIndent: 12,
            ),
            itemBuilder: (context, index) {
              final product = items[index];

              return ListTile(
                onTap: () {
                  controller.clear();
                  FocusScope.of(context).unfocus();
                  onProductSelected();

                  Navigator.pushNamed(context, AppRoutes.productDetails,
                      arguments: {
                        'product': product,
                        'variantIndex': 0,
                      });
                },
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: cs.primary.withValues(alpha: 0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: getVariantImages(product).isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: getVariantImages(product).first,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: cs.primary.withValues(alpha: 0.1)),
                            errorWidget: (_, __, ___) => Icon(
                              Icons.image_not_supported,
                              size: 20,
                              color: cs.primary,
                            ),
                          )
                        : Icon(
                            Icons.image_not_supported,
                            size: 20,
                            color: cs.primary,
                          ),
                  ),
                ),
                title: Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                subtitle: Text(
                  product.brand,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: cs.primary.withValues(alpha: 0.5),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              controller.clear();
              FocusScope.of(context).unfocus();
              onProductSelected();
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: cs.primary,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
