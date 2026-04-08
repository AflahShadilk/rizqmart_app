import 'package:flutter/widgets.dart';

// ---------------- SizedBox Extension ----------------

extension SizedBoxExtension on num {
  
  SizedBox get h => SizedBox(height: toDouble());

  
  SizedBox get w => SizedBox(width: toDouble());
}
