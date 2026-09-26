

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


// ---------------- Shimmer Placeholder ----------------

/// A base shimmer effect widget used as a loading placeholder for UI elements.
class ShimmerPlaceholder extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final BoxShape shape;

  // ---------------- Constructor ----------------

  const ShimmerPlaceholder({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  // ---------------- Build Method ----------------

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

// ---------------- Circular Shimmer Placeholder ----------------

/// A circular variation of the shimmer placeholder, typically used for profile images or icons.
class CircularShimmerPlaceholder extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final double size;

  // ---------------- Constructor ----------------

  const CircularShimmerPlaceholder({
    super.key,
    this.size = 60,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return ShimmerPlaceholder(
      height: size,
      width: size,
      shape: BoxShape.circle,
    );
  }
}


// ---------------- Rectangular Shimmer Placeholder ----------------

/// A rectangular variation of the shimmer placeholder with customizable border radius.
class RectangularShimmerPlaceholder extends StatelessWidget {
  
  // ---------------- Variables / Parameters ----------------

  final double height;
  final double width;
  final double borderRadius;

  // ---------------- Constructor ----------------

  const RectangularShimmerPlaceholder({
    super.key,
    this.height = 200,
    this.width = double.infinity,
    this.borderRadius = 12,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return ShimmerPlaceholder(
      height: height,
      width: width,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}