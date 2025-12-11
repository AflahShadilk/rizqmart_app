import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cart/cart_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/cart/widget/cart_widgets.dart';
import 'package:rizqmart/features/auth/presentation/widgets/bloc%20helper/circular_progress.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';
import 'package:rizqmart/features/auth/presentation/widgets/page_reusable_widgets/main_heading.dart';
import 'package:rizqmart/features/auth/presentation/widgets/show_toast_actions.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<CartBloc>().add(const GetCartItemsEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.cs.surface,
      appBar: AppBar(
        title: const AppHeading('My Cart'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartErrorState) {
            showToast(context, state.message, type: ToastType.error);
           
          }
          if (state is CartSuccessState) {
            showToast(context, state.messaage, type: ToastType.success);
          }
        },
        builder: (context, state) {
  
          
          if (state is CartLoadingState) {
            return circularProgressIndicators();
          }
          if (state is CartEmptyState) {
            return emptyCart(context);
          }
          if (state is CartLoadedState) {
        
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProductContainer(cartitems: item),
                      );
                    },
                  ),
                ),
                cardSummery(context, state),
                10.h
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}