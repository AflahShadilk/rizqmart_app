import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';

class ServingSelector extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const ServingSelector({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<ServingSelector> createState() => _ServingSelectorState();
}

class _ServingSelectorState extends State<ServingSelector> {
  late int _selected;

  static const _options = [2, 4, 6, 8];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _options.map((count) {
        final isSelected = _selected == count;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              setState(() => _selected = count);
              widget.onChanged(count);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              width: 52,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? context.cs.primary
                    : context.cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? null
                    : Border.all(
                        color: context.cs.outline.withValues(alpha: 0.4),
                      ),
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: context.ts.titleMedium?.copyWith(
                    color: isSelected
                        ? context.cs.onPrimary
                        : context.cs.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
