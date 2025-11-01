import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool>? onChanged;
  const LikeButton({super.key, this.initialValue = false, this.onChanged});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late bool isFavorite;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialValue;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.3).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
      ),
      child: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
          color:
              // ignore: deprecated_member_use
              isFavorite ? Colors.red : colorScheme.onSurface.withOpacity(0.6),
          size: 28,
        ),
        onPressed: () {
          setState(() => isFavorite = !isFavorite);
          _animationController.forward(from: 0.0);
          widget.onChanged?.call(isFavorite);
        },
      ),
    );
  }
}