// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/domain/entities/main/product_entities.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/variant_det_getter.dart';
import 'package:rizqmart/features/auth/presentation/pages/product_details_page/view_details_page.dart';

Widget searchResultsDropdown({
  required BuildContext context,
  required TextEditingController controller,
  required List<ProductEntities> items,
  required VoidCallback onProductSelected,
}) {
  final cs = Theme.of(context).colorScheme;

  return Material(
    elevation: 8,
    borderRadius: BorderRadius.circular(12),
    color: cs.surface,
    child: Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cs.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length > 5 ? 5 : items.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: cs.onBackground.withOpacity(0.1),
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

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductDetailsPage(product: product),
                ),
              );
            },
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: cs.primary.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: getVariantImages(product).isNotEmpty
                    ? Image.network(
                        getVariantImages(product).first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
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
                color: cs.onSurface.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: cs.primary.withOpacity(0.5),
            ),
          );
        },
      ),
    ),
  );
}
