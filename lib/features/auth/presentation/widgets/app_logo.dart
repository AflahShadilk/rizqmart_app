import 'package:flutter/material.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/icon_and_name.dart';

class CommonAppLogo extends StatelessWidget {
  const CommonAppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(150),
          bottom: Radius.circular(150),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IconRizq(),
          12.h,
          const RizqMartName(),
        ],
      ),
    );
  }
}