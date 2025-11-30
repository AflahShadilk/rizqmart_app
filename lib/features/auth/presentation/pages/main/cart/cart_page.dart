// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/dashboard/widgets/quantity_counter.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/image_relate/reusable_image_container.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
       appBar: AppBar(
        title: AppHeading('My Cart'),
        centerTitle: true,
       ),
       body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        // child: ,
       ) ,
    );
  }
}
class ProductContainer extends StatefulWidget {
  
  const ProductContainer({super.key,required this.imageUrl,required this.productName,required this.productVariantName});
  final String imageUrl;
  final String productName;
  final String productVariantName;
  @override
  State<ProductContainer> createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           ProductImage(imageUrl:widget.imageUrl,height: 100,width: 100,),
           Column(
            children: [
              Text(widget.productName,style: context.ts.titleMedium,),
              Text(widget.productVariantName,style:context.ts.labelMedium,)
            ],
           ),
           quantityButton(context.cs)
        ],
      ),
    );
  }
}