import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rizqmart/features/domain/entities/main/coupon_entity.dart';
import 'package:rizqmart/features/presentation/pages/main/dashboard/widgets/coupon_card.dart';

// ---------------- Controllers & Classes ----------------

/// A horizontally scrolling list of coupon cards that automatically advances on a timer.
class AutoScrollingCouponList extends StatefulWidget {
  final List<CouponEntity> coupons;

  const AutoScrollingCouponList({super.key, required this.coupons});

  @override
  State<AutoScrollingCouponList> createState() => _AutoScrollingCouponListState();
}

class _AutoScrollingCouponListState extends State<AutoScrollingCouponList> {
  // ---------------- Variables ----------------
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  // ---------------- Init State ----------------

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients) {
        final double maxScrollExtent = _scrollController.position.maxScrollExtent;
        final double currentScrollPosition = _scrollController.position.pixels;
        // Scroll amount is roughly the width of a CouponCard (250) + margins (8) -> ~258
        const double scrollAmount = 258.0;

        if (maxScrollExtent > 0) {
          if (currentScrollPosition >= maxScrollExtent - 10) { // small tolerance
            _scrollController.animateTo(
              0.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            _scrollController.animateTo(
              currentScrollPosition + scrollAmount,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      }
    });
  }

  // ---------------- Dispose ----------------
  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    // Horizontally scrolling list of coupons with automatically driven scroll controller
    return SizedBox(
      height: 160,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: widget.coupons.length,
        itemBuilder: (context, index) {
          return CouponCard(coupon: widget.coupons[index]);
        },
      ),
    );
  }
}
