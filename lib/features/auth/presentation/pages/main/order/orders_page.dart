import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/data/model/main/order_firestore_model.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/orders/orders_page_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/order/orders/orders_page_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/order/order_bloc.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/core/theme/app_colors.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/order/widgets/order_card.dart';

// ---------------- Orders Page ----------------

/// A page displaying a chronologically ordered list of the user's past and active orders.
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          OrdersPageCubit(orderBloc: context.read<OrderBloc>()),
      child: const _OrdersView(),
    );
  }
}

// ---------------- Orders View ----------------

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  // ---------------- Helper Methods ----------------

  void _onPopInvoked(BuildContext context, bool didPop, bool canPop) {
    if (didPop) return;
    Navigator.pushReplacementNamed(context, AppRoutes.navigationBar);
  }

  void _onBackPressed(BuildContext context, bool canPop) {
    if (canPop) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.navigationBar);
    }
  }

  void _onOrdersPageCubitStateChange(BuildContext context, OrdersPageState state) {
    if (state is OrdersPageCancelSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.success500,
        ),
      );
    }
  }

  // ---------------- Build Method ----------------
  @override
  Widget build(BuildContext context) {
    // ---------------- Variables ----------------
    final bool canPop = Navigator.canPop(context);
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    // ---------------- UI Rendering ----------------
    return BlocListener<OrdersPageCubit, OrdersPageState>(
      listener: _onOrdersPageCubitStateChange,
      child: PopScope(
        canPop: canPop,
        // ignore: deprecated_member_use
        onPopInvoked: (didPop) => _onPopInvoked(context, didPop, canPop),
        child: Scaffold(
          backgroundColor: context.cs.surface,

          // ---------------- Orders Page Header ----------------
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _onBackPressed(context, canPop),
            ),
            title: Text(
              'My Orders',
              style: context.ts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: context.cs.surface,
            elevation: 0,
          ),

          // ---------------- Orders List Body (Real-time from Firebase) ----------------
          body: currentUserId == null
              ? Center(
                  child: Text('Please log in to view orders',
                      style: context.ts.titleMedium),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('userId', isEqualTo: currentUserId)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                size: 48, color: context.cs.error),
                            16.h,
                            Text('Error: ${snapshot.error}'),
                          ],
                        ),
                      );
                    }

                    final docs = snapshot.data?.docs ?? [];

                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 64,
                              color: context.cs.onSurface.withAlpha(77),
                            ),
                            16.h,
                            Text('No orders yet', style: context.ts.titleMedium),
                            8.h,
                            Text(
                              'Start shopping to see your orders here',
                              style: context.ts.bodySmall?.copyWith(
                                color: context.cs.onSurface.withAlpha(128),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final orders = docs
                        .map((doc) => OrderFirestoreModel.fromFirestore(doc))
                        .toList();

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: orders.length,
                      separatorBuilder: (context, index) => 16.h,
                      itemBuilder: (context, index) {
                        return OrderCard(order: orders[index]);
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
