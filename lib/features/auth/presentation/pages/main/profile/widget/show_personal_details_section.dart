import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/user_profile_entities.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
class ShowPersonalDetailsSection extends StatelessWidget {
  final UserProfileEntities profile;

  const ShowPersonalDetailsSection({
    super.key,
    required this.profile,
  });
Widget _buildSectionTitle(BuildContext context, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: context.ts.labelLarge?.copyWith(
          color: context.cs.onSurface,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildInfoField(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.cs.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cs.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: context.cs.onSurfaceVariant,
            size: 20,
          ),
          16.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.ts.labelSmall?.copyWith(
                    color: context.cs.onSurfaceVariant,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
                4.h,
                Text(
                  value,
                  style: context.ts.bodyMedium?.copyWith(
                    color: context.cs.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not specified';
    return '${date.day}/${date.month}/${date.year}';
  }
@override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSectionTitle(context, 'Personal Details'),
        14.h,
        _buildInfoField(context, 'Date of Birth',
            _formatDate(profile.dateOfBirth), Icons.cake_outlined),
        12.h,
        _buildInfoField(
            context, 'Gender', profile.gender ?? 'Not specified', Icons.wc),
      ],
    );
  }
}
