import 'package:flutter/material.dart';

/// State object holding a unified label text and UI color matching the order phase.
class OrderStatusState {
  final String label;
  final Color color;

  const OrderStatusState({required this.label, required this.color});
}