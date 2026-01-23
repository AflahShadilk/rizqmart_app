import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              16.w,
              Text('Signing out...'),
            ],
          ),
        ),
      );
    },
  );
}