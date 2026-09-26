

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/presentation/cubits/dashboard/banner_cubit.dart';
import 'package:rizqmart/features/presentation/cubits/dashboard/banner_state.dart';

// ---------------- Offer Banner Widget ----------------

class OfferBannerWidget extends StatelessWidget {
  const OfferBannerWidget({super.key});

  static final List<Map<String, dynamic>> _demoOffers = [
    {
      "title": "Fresh Vegetables",
      "subtitle": "Farm Fresh Quality",
      "discount": "50% OFF",
      "color": const Color(0xFF4CAF50),
      "icon": Icons.eco,
      "image": "assets/icons_and_images/vegetables.png"
    },
    {
      "title": "Cool Drinks",
      "subtitle": "Summer Refreshment",
      "discount": "Buy 1 Get 1",
      "color": const Color(0xFFFF9800),
      "icon": Icons.local_drink,
      "image": "assets/icons_and_images/drinks.png"
    },
    {
      "title": "Groceries",
      "subtitle": "Daily Essentials",
      "discount": "Upto 30% OFF",
      "color": const Color(0xFF2196F3),
      "icon": Icons.shopping_basket,
      "image": "assets/icons_and_images/grocery.png"
    },
    {
      "title": "Special Deal",
      "subtitle": "Limited Time Offer",
      "discount": "Flat ₹100 OFF",
      "color": const Color(0xFFE91E63),
      "icon": Icons.local_offer,
      "image": "assets/icons_and_images/offer.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BannerCubit(totalItems: _demoOffers.length)..startAutoScroll(),
      child: _BannerBody(offers: _demoOffers),
    );
  }
}

// ---------------- Banner Body StatefulWidget ----------------

class _BannerBody extends StatefulWidget {
  final List<Map<String, dynamic>> offers;
  const _BannerBody({required this.offers});

  @override
  State<_BannerBody> createState() => _BannerBodyState();
}

class _BannerBodyState extends State<_BannerBody> {
  
  // ---------------- State Variables ----------------

  final PageController _pageController = PageController();

  // ---------------- Lifecycle Methods ----------------

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ---------------- Build Method ----------------


  @override
  Widget build(BuildContext context) {
    return BlocListener<BannerCubit, BannerState>(
      listener: (context, state) {
        if (state is BannerPageUpdated) {
          // Verify we aren't already on the page (to avoid conflict with gesture swipe)
          // or just animate always if it comes from timer.
          // Since updatePage resets timer, manual swipe won't fight timer immediately.
          if (_pageController.hasClients) {
             // Calculate difference to decide animation (optional)
             // Simple animateToPage handles it well usually.
             _pageController.animateToPage(
               state.currentPage,
               duration: const Duration(milliseconds: 600),
               curve: Curves.easeInOut,
             );
          }
        }
      },
      child: SizedBox(
        height: 240,
        child: PageView.builder(
          controller: _pageController,
          itemCount: widget.offers.length,
          onPageChanged: (int page) {
            // Update cubit state, which also resets timer
            context.read<BannerCubit>().updatePage(page);
          },
          itemBuilder: (context, index) {
            final offer = widget.offers[index];
            return _buildBannerCard(context, offer);
          },
        ),
      ),
    );
  }

  Widget _buildBannerCard(BuildContext context, Map<String, dynamic> offer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            offer['color'] as Color,
            (offer['color'] as Color).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (offer['color'] as Color).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              offer['icon'] as IconData,
              size: 150,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          offer['subtitle'] as String,
                          style: context.ts.labelSmall?.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      8.h,
                      Text(
                        offer['title'] as String,
                        style: context.ts.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.h,
                      Text(
                        offer['discount'] as String,
                        style: context.ts.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      12.h,
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          'Shop Now',
                          style: context.ts.labelSmall?.copyWith(
                            color: offer['color'] as Color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Icon(
                      offer['icon'] as IconData,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
