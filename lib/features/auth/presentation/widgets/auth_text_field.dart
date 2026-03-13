import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
class TextFormFLogin extends StatefulWidget {
final String? hint;
  final IconData? iconn;
  final Color? iconnColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Function(String)? onChanged;
  final int? maxLength;
const TextFormFLogin({
    super.key,
    this.hint,
    this.iconn,
    this.iconnColor,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText,
    this.onChanged,
    this.maxLength,
  });

  @override
  State<TextFormFLogin> createState() => _TextFormFLoginState();
}

class _TextFormFLoginState extends State<TextFormFLogin> {
@override
  Widget build(BuildContext context) {
    final activeColor = widget.iconnColor ?? context.cs.primary;

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.obscureText ?? false,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hint,
        labelStyle: context.ts.bodyMedium,
        prefixIcon: widget.iconn != null
            ? Icon(widget.iconn, color: activeColor)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: activeColor, width: 1.8),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: context.cs.surfaceContainerHighest,
      ),
      style: context.ts.bodyMedium,
    );
  }
}
