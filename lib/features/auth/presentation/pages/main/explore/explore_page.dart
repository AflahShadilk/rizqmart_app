// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/explore/product_by_category_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc%20helper/circular_progress.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}
class _ExplorePageState extends State<ExplorePage> {

  final List<Color> cardColors = [
    const Color(0xFFFFF3E0), 
    const Color(0xFFE8F5E8), 
    const Color(0xFFE3F2FD), 
    const Color(0xFFFFEBEE), 
    const Color(0xFFF3E5F5), 
    const Color(0xFFFFFDE7), 
    const Color(0xFFE0F7FA), 
    const Color(0xFFFCE4EC), 
  ];

  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(GetCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Find Product',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: (q) {
                  if (q.isEmpty) {
                    context.read<ExploreBloc>().add(GetCategoriesEvent());
                  } else {
                    context.read<ExploreBloc>().add(SearchProductsEvent(q));
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      context.read<ExploreBloc>().add(GetCategoriesEvent());
                    },
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.green.shade400, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ExploreBloc, ExploreState>(
                builder: (context, state) {
                  if (state is ExploreLoadingState) {
                    return  Center(child: circularProgressIndicators());
                  }
                  if (state is ExploreFailureState) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Error: ${state.message}'),
                          IconButton(
                            onPressed: () => context.read<ExploreBloc>().add(GetCategoriesEvent()),
                            icon: const Icon(Icons.refresh),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ExploreLoadedState) {
                    
                    if (state.products.isEmpty && state.categories.isNotEmpty) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          final cat = state.categories[index];
                          final color = cardColors[index % cardColors.length];

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductByCategoryPage(categoryName: cat.categoryName,)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      
                                      child: Image.network(
                                        cat.logoUrl,
                                        
                                        width: 80,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Icon(
                                          Icons.category,
                                          size: 40,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  Text(
                                    cat.categoryName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

