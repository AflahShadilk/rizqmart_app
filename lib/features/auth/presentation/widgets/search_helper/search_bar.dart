// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String hint;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = "Search products...",
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,

     
        cursorColor: colorScheme.primary,
        selectionControls: null,
        selectionHeightStyle: BoxHeightStyle.tight,
        selectionWidthStyle: BoxWidthStyle.tight,

        decoration: InputDecoration(
          hintText: '   ${widget.hint}',
          hintStyle: TextStyle(
            fontSize: 15,
            color: colorScheme.onSurface.withOpacity(0.5),
          ),

          suffixIcon: Icon(
            Icons.search,
            size: 22,
            color: context.cs.success,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(
              color: colorScheme.primary.withOpacity(0.5),
              width: 1.8,
            ),
          ),
           contentPadding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? colorScheme.surface.withOpacity(0.14)
              : colorScheme.primary.withOpacity(0.05),

        ),

        style: TextStyle(
          fontSize: 15,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
