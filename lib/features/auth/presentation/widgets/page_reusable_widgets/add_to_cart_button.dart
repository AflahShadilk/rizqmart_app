import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.widget,
  });

  final dynamic widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Symbols.shopping_cart,
          color: Colors.white,
          size: 18,
        ),
        onPressed: () {
         Fluttertoast.showToast(
            msg: '${widget.name} added to cart!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green[400],
            textColor: Colors.white,
            fontSize: 14.0,
          );
        },
      ),
    );
  }
}