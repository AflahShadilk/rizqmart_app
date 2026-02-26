
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/productbycategory/filteritem/filter_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/productbycategory/filteritem/filter_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

/// A modal bottom sheet providing advanced filtering options like brand, category, and variant.
class FilterBottomSheet extends StatelessWidget {
  final List<String> brands;
  final List<String> categories;
  final List<String> variants;
  final String? selectedBrand;
  final String? selectedCategory;
  final String? selectedVariant;
  final Function(String?, String?, String?) onApply;

  const FilterBottomSheet({
    super.key,
    required this.brands,
    required this.categories,
    required this.variants,
    this.selectedBrand,
    this.selectedCategory,
    this.selectedVariant,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return BlocProvider(
      create: (context) => FiltersCubit(
        initialBrand: selectedBrand,
        initialCategory: selectedCategory,
        initialVariant: selectedVariant,
      ),
      child: BlocBuilder<FiltersCubit, FiltersState>(
        builder: (context, state) {
          final filterCubit = context.read<FiltersCubit>();

          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: theme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filters',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () => filterCubit.clearAll(),
                      child: Text(
                        'Clear All',
                        style: TextStyle(color: theme.primary),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                10.h,

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FilterSection(
                          title: 'Brand',
                          items: brands,
                          selectedValue: state.selectedBrand,
                          onChanged: (value) => filterCubit.updateBrand(value),
                        ),
                        20.h,

                        FilterSection(
                          title: 'Category',
                          items: categories,
                          selectedValue: state.selectedCategory,
                          onChanged: (value) => filterCubit.updateCategory(value),
                        ),
                        20.h,

                        FilterSection(
                          title: 'Variant',
                          items: variants,
                          selectedValue: state.selectedVariant,
                          onChanged: (value) => filterCubit.updateVariant(value),
                        ),
                      ],
                    ),
                  ),
                ),

                16.h,
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: MainButton(
                    label: 'Apply Filter',
                    icon: Icons.filter_alt_outlined,
                    onPress: () {
                      onApply(
                        state.selectedBrand,
                        state.selectedCategory,
                        state.selectedVariant,
                      );
                      Navigator.pop(context);
                    },
                    color: context.cs.primary,
                    textColor: context.cs.surface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A reusable section widget for rendering a group of selectable filter chips based on a list of items.
class FilterSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? selectedValue;
  final Function(String?) onChanged;

  const FilterSection({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: theme.onSurface,
          ),
        ),
        10.h,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            final isSelected = selectedValue == item;
            return FilterChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (selected) {
                onChanged(selected ? item : null);
              },
              selectedColor: theme.primary.withValues(alpha: 0.2),
              checkmarkColor: theme.primary,
              labelStyle: TextStyle(
                color: isSelected ? theme.primary : theme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? theme.primary : Colors.grey.shade300,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}