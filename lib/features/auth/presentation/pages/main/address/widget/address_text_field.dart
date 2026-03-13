import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
class AddressTextField extends StatefulWidget {
  final String? initialValue;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final int? maxLength;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const AddressTextField({
    super.key,
    this.initialValue,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    required this.onChanged,
    this.validator,
  });

  @override
  State<AddressTextField> createState() => _AddressTextFieldState();
}

class _AddressTextFieldState extends State<AddressTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant AddressTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: context.ts.bodyMedium?.copyWith(
        color: context.cs.onSurface,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: context.ts.bodySmall?.copyWith(
          color: context.cs.onSurfaceVariant,
          fontSize: 12,
        ),
        prefixIcon: Icon(
          widget.icon,
          color: context.cs.onSurfaceVariant,
          size: 18,
        ),
        filled: true,
        fillColor: context.cs.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.outlineVariant.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.error.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: context.cs.error,
            width: 1.5,
          ),
        ),
        counterText: widget.maxLength != null ? null : '',
        errorStyle: TextStyle(
          color: context.cs.error,
          fontSize: 11,
        ),
      ),
    );
  }
}
