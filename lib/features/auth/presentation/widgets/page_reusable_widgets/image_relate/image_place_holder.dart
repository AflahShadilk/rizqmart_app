

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  const ShimmerPlaceholder({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
          shape: shape,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}

class CircularShimmerPlaceholder extends StatelessWidget {
  final double size;

  const CircularShimmerPlaceholder({
    super.key,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerPlaceholder(
      height: size,
      width: size,
      shape: BoxShape.circle,
    );
  }
}


class RectangularShimmerPlaceholder extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const RectangularShimmerPlaceholder({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerPlaceholder(
      height: height,
      width: width,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}