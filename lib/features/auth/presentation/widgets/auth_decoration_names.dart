import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

// ---------------- Field Category Name ----------------

Padding fieldCatogoryName(BuildContext context, String name) {
  return Padding(
    padding: const EdgeInsets.all(8),
    child: Text(
      name,
      style: context.ts.bodyLarge?.copyWith(
        color: context.cs.onSurface,
      ),
    ),
  );
}

// ---------------- Field Headline ----------------

Align fieldHeadline(BuildContext context, String name) {
  return Align(
    alignment: Alignment.topCenter,
    child: Text(
      name,
      style: context.ts.titleLarge?.copyWith(
        color: context.cs.onSurface,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}