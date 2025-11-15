// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/auth/domain/entities/main/explore_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc%20helper/circular_progress.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/add_to_cart_button.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ProductByCategoryPage extends StatefulWidget {
  final String categoryName;
  const ProductByCategoryPage({super.key, required this.categoryName});

  @override
  State<ProductByCategoryPage> createState() => _ProductByCategoryPageState();
}

class _ProductByCategoryPageState extends State<ProductByCategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(
      GetProductsByCategoryEvent(widget.categoryName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context).colorScheme;
    return Scaffold(

       backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        
        title: Text(widget.categoryName,style:  GoogleFonts.poppins(color: theme.onBackground,fontSize: 20,fontWeight: FontWeight.w900),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon:Icon(Symbols.settings,color:theme.primary,)),
        ],
      ),
      body: BlocBuilder<ExploreBloc, ExploreState>(
        builder: (context, state) {
  
          if (state is ExploreLoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  circularProgressIndicators(),
                  const SizedBox(height: 16),
                  const Text('Loading products...'),
                ],
              ),
            );
          }

        
          if (state is ExploreFailureState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 50, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ExploreBloc>().add(
                        GetProductsByCategoryEvent(widget.categoryName),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          
          if (state is ExploreLoadedState) {
            List<ExploreEntities> allProducts = state.products;

          
            if (allProducts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('No products found'),
                  ],
                ),
              );
            }

      
            List<Map<String, dynamic>> allVariants = [];

  
            for (var product in allProducts) {
    
              if (product.variantDetails.isEmpty) {
                continue;
              }
              for (int i = 0; i < product.variantDetails.length; i++) {
                Map<String, dynamic> variantItem = {
                  'product': product,
                  'variantIndex': i,
                };
                
                allVariants.add(variantItem);
              }
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: allVariants.length,
              itemBuilder: (context, index) {
                ExploreEntities product = allVariants[index]['product'];
                int variantIndex = allVariants[index]['variantIndex'];

                Map<String, dynamic> variant = product.variantDetails[variantIndex];

                List<String> imageList = List<String>.from(variant['imageUrls'] ?? []);
                String image = imageList.isNotEmpty ? imageList[0] : '';
                String unitName = variant['unitName'] ?? '';
                String unitType = variant['unitType'] ?? '';
                double price = (variant['mrp'] ?? 0).toDouble();

                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                        child: Image.network(
                          image,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              height: 100,
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.image_not_supported),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const SizedBox(height: 4),
                              Text(
                                '$unitName $unitType',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '₹${price.toInt()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                  AddToCartButton(widget: product),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Loading...'));
        },
      ),
    );
  }
}