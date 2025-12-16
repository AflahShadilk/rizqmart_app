// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
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
        return Row(
          children: [
            Expanded(
              child: AddressLabelOption(
                label: 'Home',
                icon: Icons.home,
                isSelected: state.label == 'Home',
                onTap: () =>
                    context.read<AddressFormCubit>().updateLabel('Home'),
              ),
            ),
            12.w,
            Expanded(
              child: AddressLabelOption(
                label: 'Work',
                icon: Icons.work,
                isSelected: state.label == 'Work',
                onTap: () =>
                    context.read<AddressFormCubit>().updateLabel('Work'),
              ),
            ),
            12.w,
            Expanded(
              child: AddressLabelOption(
                label: 'Other',
                icon: Icons.location_on,
                isSelected: state.label == 'Other',
                onTap: () =>
                    context.read<AddressFormCubit>().updateLabel('Other'),
              ),
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? context.cs.primary.withOpacity(0.08)
              : context.cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? context.cs.primary.withOpacity(0.4)
                : context.cs.outlineVariant.withOpacity(0.3),
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? context.cs.primary : context.cs.onSurfaceVariant,
              size: 20,
            ),
            6.h,
            Text(
              label,
              style: context.ts.labelSmall?.copyWith(
                color: isSelected ? context.cs.primary : context.cs.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}