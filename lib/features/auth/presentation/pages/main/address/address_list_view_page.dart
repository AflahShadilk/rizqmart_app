

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

/// Reusable address list for both display and selection modes
class AddressListView extends StatelessWidget {
  final List<AddressEntities> addresses;
  final String userId;
  final VoidCallback onAddAddress;
  final Function(AddressEntities)? onEditAddress;
  final Function(AddressEntities)? onDeleteAddress;
  final bool isSelecting;
  final String? selectedAddressId;
  final Function(AddressEntities)? onSelect;

  const AddressListView({
    super.key,
    required this.addresses,
    required this.userId,
    required this.onAddAddress,
    this.onEditAddress,
    this.onDeleteAddress,
    this.isSelecting = false,
    this.selectedAddressId,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: addresses.length,
      separatorBuilder: (context, index) => 12.h,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return AddressCardItem(
          address: address,
          userId: userId,
          isSelecting: isSelecting,
          isSelected: selectedAddressId == address.id,
          onSelect: onSelect != null ? () => onSelect!(address) : null,
          onEdit: onEditAddress != null ? () => onEditAddress!(address) : null,
          onDelete: onDeleteAddress != null ? () => onDeleteAddress!(address) : null,
          onSetDefault: isSelecting ? null : () => _setDefaultAddress(context, address),
        );
      },
    );
  }

  void _setDefaultAddress(BuildContext context, AddressEntities address) {
    context.read<AddressBloc>().add(SetDefaultAddressEvent(
          addressId: address.id,
          userId: userId,
        ));
  }
}

/// Address card used in both address page and checkout selection
class AddressCardItem extends StatelessWidget {
  final AddressEntities address;
  final String userId;
  final bool isSelecting;
  final bool isSelected;
  final VoidCallback? onSelect;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onSetDefault;

  const AddressCardItem({
    super.key,
    required this.address,
    required this.userId,
    this.isSelecting = false,
    this.isSelected = false,
    this.onSelect,
    this.onEdit,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? context.cs.primary
              : address.isDefault
                  ? context.cs.primary.withValues(alpha: 0.15)
                  : context.cs.outlineVariant.withValues(alpha: 0.2),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: isSelecting ? onSelect : null,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label & default badge row
              Row(
                children: [
                  _buildLabelBadge(context),
                  const Spacer(),
                  if (address.isDefault) _buildDefaultBadge(context),
                ],
              ),
              14.h,
              // Full name
              Text(
                address.fullName,
                style: context.ts.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.cs.onSurface,
                ),
              ),
              10.h,
              // Phone row
              _buildInfoRow(context, Icons.phone, address.phoneNumber),
              8.h,
              // Address text row
              _buildAddressText(context, address),
              // Action buttons (only in non-selection mode)
              if (!isSelecting) ...[
                14.h,
                _buildActionRow(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabelBadge(BuildContext context) {
    final color = _getLabelColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        address.label,
        style: context.ts.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildDefaultBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: context.cs.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 12,
            color: context.cs.primary,
          ),
          3.w,
          Text(
            'Default',
            style: context.ts.labelSmall?.copyWith(
              color: context.cs.primary,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: context.cs.onSurfaceVariant,
        ),
        6.w,
        Expanded(
          child: Text(
            text,
            style: context.ts.bodySmall?.copyWith(
              color: context.cs.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressText(BuildContext context, AddressEntities address) {
    final fullAddress =
        
        '${address.address1}${address.address2.isNotEmpty ? ', ${address.address2}' : ''}, ${address.city}, ${address.state} ${address.pincode}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.location_on,
          size: 14,
          color: context.cs.onSurfaceVariant,
        ),
        6.w,
        Expanded(
          child: Text(
            fullAddress,
            style: context.ts.bodySmall?.copyWith(
              color: context.cs.onSurfaceVariant,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildActionRow(BuildContext context) {
    return Row(
      children: [
        if (onEdit != null)
          Expanded(
            child: _buildActionButton(
              context,
              Icons.edit,
              'Edit',
              onEdit!,
              isPrimary: true,
            ),
          ),
        if (onEdit != null) 8.w,
        if (!address.isDefault && onSetDefault != null)
          Expanded(
            child: _buildActionButton(
              context,
              Icons.check_circle_outline,
              'Default',
              onSetDefault!,
              isPrimary: true,
            ),
          )
        else
          const SizedBox.shrink(),
        if (!address.isDefault && onSetDefault != null) 8.w,
        if (onDelete != null)
          Expanded(
            child: _buildActionButton(
              context,
              Icons.delete_outline,
              'Delete',
              onDelete!,
              isPrimary: false,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed, {
    bool isPrimary = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
          decoration: BoxDecoration(
            color: isPrimary
                ? context.cs.primary.withValues(alpha: 0.08)
                : context.cs.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isPrimary ? context.cs.primary : context.cs.error,
              ),
              2.w,
              Expanded(
                child: Text(
                  label,
                  style: context.ts.labelSmall?.copyWith(
                    color: isPrimary ? context.cs.primary : context.cs.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getLabelColor(BuildContext context) {
    switch (address.label.toLowerCase()) {
      case 'home':
        return const Color(0xFF6366F1);
      case 'work':
        return const Color(0xFF0EA5E9);
      case 'other':
        return const Color(0xFF8B5CF6);
      default:
        return context.cs.primary;
    }
  }
}