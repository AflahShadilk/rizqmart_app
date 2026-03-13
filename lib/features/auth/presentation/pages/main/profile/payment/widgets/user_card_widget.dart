

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class UserCardWidget extends StatelessWidget {
  final SavedCardEntity card;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const UserCardWidget({
    super.key,
    required this.card,
    this.isSelected = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Color(card.cardColor),
              Color(card.cardColor).withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(card.cardColor).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  card.brand.toUpperCase(),
                  style: context.ts.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            20.h,
            Text(
              '**** **** **** ${card.last4}',
              style: context.ts.headlineSmall?.copyWith(
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            20.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CARD HOLDER',
                      style: context.ts.labelSmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    4.h,
                    Text(
                      card.cardHolderName.toUpperCase(),
                      style: context.ts.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EXPIRES',
                      style: context.ts.labelSmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    4.h,
                    Text(
                      '${card.expiryMonth}/${card.expiryYear.toString().substring(2)}',
                      style: context.ts.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
