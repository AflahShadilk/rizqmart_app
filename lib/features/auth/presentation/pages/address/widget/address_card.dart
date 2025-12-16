import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class AddressCard extends StatelessWidget {
  final AddressEntities address;
  final String userId;
  final VoidCallback onEdit;

  const AddressCard({
    super.key,
    required this.address,
    required this.userId,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isDefault
              ? context.cs.primary
              : context.cs.outlineVariant,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: address.isDefault
                        ? context.cs.primaryContainer
                        : context.cs.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getLabelIcon(address.label),
                        size: 16,
                        color: address.isDefault
                            ? context.cs.onPrimaryContainer
                            : context.cs.onSecondaryContainer,
                      ),
                      6.w,
                      Text(
                        address.label,
                        style: context.ts.labelMedium?.copyWith(
                          color: address.isDefault
                              ? context.cs.onPrimaryContainer
                              : context.cs.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.cs.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'DEFAULT',
                      style: context.ts.labelSmall?.copyWith(
                        color: context.cs.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            16.h,
            Text(
              address.fullName,
              style: context.ts.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            4.h,
            Text(
              address.phoneNumber,
              style: context.ts.bodyMedium?.copyWith(
                color: context.cs.onSurfaceVariant,
              ),
            ),
            12.h,
            Text(
              '${address.address1}, ${address.address2}',
              style: context.ts.bodyMedium,
            ),
            4.h,
            Text(
              '${address.city}, ${address.state} - ${address.pincode}',
              style: context.ts.bodyMedium,
            ),
            16.h,
            Row(
              children: [
                if (!address.isDefault)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AddressBloc>().add(
                              SetDefaultAddressEvent(
                                userId: userId,
                                addressId: address.id,
                              ),
                            );
                      },
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text('Set Default'),
                      style: OutlinedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w800),
                        foregroundColor: context.cs.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        minimumSize: const Size(0, 32),
                        side: BorderSide(color: context.cs.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                if (!address.isDefault) 12.w,
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.cs.onSurface,
                      side: BorderSide(color: context.cs.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                12.w,
                OutlinedButton(
                  onPressed: () => _showDeleteDialog(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.cs.error,
                    side: BorderSide(color: context.cs.error),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Icon(Icons.delete_outline, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getLabelIcon(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home_outlined;
      case 'work':
        return Icons.work_outline;
      case 'other':
        return Icons.location_on_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Address'),
        content: const Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AddressBloc>().add(
                    DeleteAddressEvent(
                      userId: userId,
                      addressId: address.id,
                    ),
                  );
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(
              foregroundColor: context.cs.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
