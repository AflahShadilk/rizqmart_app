import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_form_cubit/address_form_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/address/address_form_cubit/address_form_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class AddressLabelSelector extends StatelessWidget {
  const AddressLabelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressFormCubit, AddressFormState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Address Type',
              style: context.ts.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            12.h,
            Row(
              children: [
                Expanded(
                  child: AddressLabelOption(
                    label: 'Home',
                    icon: Icons.home_outlined,
                    isSelected: state.label == 'Home',
                    onTap: () =>
                        context.read<AddressFormCubit>().updateLabel('Home'),
                  ),
                ),
                12.w,
                Expanded(
                  child: AddressLabelOption(
                    label: 'Work',
                    icon: Icons.work_outline,
                    isSelected: state.label == 'Work',
                    onTap: () =>
                        context.read<AddressFormCubit>().updateLabel('Work'),
                  ),
                ),
                12.w,
                Expanded(
                  child: AddressLabelOption(
                    label: 'Other',
                    icon: Icons.location_on_outlined,
                    isSelected: state.label == 'Other',
                    onTap: () =>
                        context.read<AddressFormCubit>().updateLabel('Other'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class AddressLabelOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressLabelOption({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.cs.primaryContainer
              : context.cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? context.cs.primary : context.cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? context.cs.onPrimaryContainer
                  : context.cs.onSurfaceVariant,
              size: 28,
            ),
            8.h,
            Text(
              label,
              style: context.ts.bodyMedium?.copyWith(
                color: isSelected
                    ? context.cs.onPrimaryContainer
                    : context.cs.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}