// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/explore/explore_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/explore/product_by_category_page.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc helper/circular_progress.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  bool _isSearching = false;
  List<dynamic> _allCategories = [];
  List<dynamic> _filteredCategories = [];

  final List<Color> cardColors = [
    Color(0xFFFFF3E0),
    Color(0xFFE8F5E8),
    Color(0xFFE3F2FD),
    Color(0xFFFFEBEE),
    Color(0xFFF3E5F5),
    Color(0xFFFFFDE7),
    Color(0xFFE0F7FA),
    Color(0xFFFCE4EC),
  ];

  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(GetCategoriesEvent());
  }

  void _onSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        _filteredCategories = [];
        return;
      }

      _filteredCategories = _allCategories
          .where((cat) =>
              cat.categoryName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
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
                    controller: _searchController,
                    onChanged: (q) {
                      _onSearch(q);

                      if (q.isEmpty) {
                        context.read<ExploreBloc>().add(GetCategoriesEvent());
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search category...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
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
                        borderSide:
                            BorderSide(color: Colors.green.shade400, width: 2),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

           
                Expanded(
                  child: BlocBuilder<ExploreBloc, ExploreState>(
                    builder: (context, state) {
                      if (state is ExploreLoadingState) {
                        return Center(child: circularProgressIndicators());
                      }

                      if (state is ExploreFailureState) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Error: ${state.message}'),
                              IconButton(
                                onPressed: () =>
                                    context.read<ExploreBloc>().add(GetCategoriesEvent()),
                                icon: const Icon(Icons.refresh),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is ExploreLoadedState) {
                       
                        _allCategories = state.categories;

                        final displayCategories = _isSearching
                            ? _filteredCategories
                            : state.categories;

                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: displayCategories.length,
                          itemBuilder: (context, index) {
                            final cat = displayCategories[index];
                            final color =
                                cardColors[index % cardColors.length];

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductByCategoryPage(
                                      categoryName: cat.categoryName,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 12,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
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

                      return SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),

         
          if (_isSearching && _filteredCategories.isNotEmpty)
            Positioned(
              top: 140,
              left: 16,
              right: 16,
              child: _buildSearchDropdown(colorScheme),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchDropdown(ColorScheme colorScheme) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: colorScheme.surface,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount:
              _filteredCategories.length > 5 ? 5 : _filteredCategories.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: colorScheme.onBackground.withOpacity(0.1),
            indent: 12,
            endIndent: 12,
          ),
          itemBuilder: (context, index) {
            final cat = _filteredCategories[index];

            return ListTile(
              onTap: () {
                _searchController.text = cat.categoryName;
                _onSearch(cat.categoryName);
                FocusScope.of(context).unfocus(); 
                _searchController.clear();
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProductByCategoryPage(categoryName:)))
              },
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  cat.logoUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.category,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              title: Text(
                cat.categoryName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: colorScheme.primary.withOpacity(0.5),
              ),
            );
          },
        ),
      ),
    );
  }
}
