import 'package:flutter/widgets.dart';

extension SizedBoxExtension on num {
  /// Vertical 
  SizedBox get h => SizedBox(height: toDouble());

  /// Horizontal 
  SizedBox get w => SizedBox(width: toDouble());
}
