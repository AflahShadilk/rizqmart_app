// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class OfferBannerWidget extends StatefulWidget {
  const OfferBannerWidget({super.key});

  @override
  State<OfferBannerWidget> createState() => _OfferBannerWidgetState();
}

class _OfferBannerWidgetState extends State<OfferBannerWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _demoOffers = [
    {
      "title": "Fresh Vegetables",
      "subtitle": "Farm Fresh Quality",
      "discount": "50% OFF",
      "color": const Color(0xFF4CAF50),
      "icon": Icons.eco,
      "image": "assets/icons_and_images/vegetables.png" // Placeholder logic
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
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentPage < _demoOffers.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _demoOffers.length,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        itemBuilder: (context, index) {
          final offer = _demoOffers[index];
          return _buildBannerCard(context, offer);
        },
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
            (offer['color'] as Color).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: (offer['color'] as Color).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Icon Pattern (Optional decoration)
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              offer['icon'] as IconData,
              size: 150,
              color: Colors.white.withOpacity(0.15),
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
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          offer['subtitle'] as String,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      8.h,
                      Text(
                        offer['title'] as String,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.h,
                      Text(
                        offer['discount'] as String,
                        style: GoogleFonts.inter(
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
                          style: GoogleFonts.inter(
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
                    // Note: Replace Icon with Image.asset if assets exist
                    // child: Image.asset(offer['image'], height: 100), 
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
