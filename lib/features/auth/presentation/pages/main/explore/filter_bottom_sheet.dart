// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterBottomSheet extends StatefulWidget {
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
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? tempBrand;
  String? tempCategory;
  String? tempVariant;

  @override
  void initState() {
    super.initState();
    tempBrand = widget.selectedBrand;
    tempCategory = widget.selectedCategory;
    tempVariant = widget.selectedVariant;
  }

  void clearAll() {
    setState(() {
      tempBrand = null;
      tempCategory = null;
      tempVariant = null;
    });
  }

  void applyFilters() {
    widget.onApply(tempBrand, tempCategory, tempVariant);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

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
                  color: theme.onBackground,
                ),
              ),
              TextButton(
                onPressed: clearAll,
                child: Text(
                  'Clear All',
                  style: TextStyle(color: theme.primary),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterSection(
                    title: 'Brand',
                    items: widget.brands,
                    selectedValue: tempBrand,
                    onChanged: (value) {
                      setState(() {
                        tempBrand = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  FilterSection(
                    title: 'Category',
                    items: widget.categories,
                    selectedValue: tempCategory,
                    onChanged: (value) {
                      setState(() {
                        tempCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  FilterSection(
                    title: 'Variant',
                    items: widget.variants,
                    selectedValue: tempVariant,
                    onChanged: (value) {
                      setState(() {
                        tempVariant = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: applyFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Apply Filters',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
            color: theme.onBackground,
          ),
        ),
        const SizedBox(height: 10),
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
              selectedColor: theme.primary.withOpacity(0.2),
              checkmarkColor: theme.primary,
              labelStyle: TextStyle(
                color: isSelected ? theme.primary : theme.onBackground,
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