import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/payment_selection_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/payment_selection_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/add_money_cubit.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/get_saved_cards_usecase.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/payment/widgets/user_card_widget.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/payment/widgets/payment_selection_order_summary.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/payment/widgets/payment_option_card.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/payment/widgets/payment_info_banner.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Payment Selection Page ----------------

/// A page allowing users to choose their preferred payment method for an order,
/// including saved cards, wallet, COD, or Stripe.
class PaymentSelectionPage extends StatefulWidget {
  final OrderEntities order;

  const PaymentSelectionPage({
    super.key,
    required this.order,
  });

  @override
  State<PaymentSelectionPage> createState() => _PaymentSelectionPageState();
}

class _PaymentSelectionPageState extends State<PaymentSelectionPage> {

  // ---------------- Variables ----------------

  late final String userId;

  // ---------------- Init State ----------------

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  // ---------------- Helper Methods ----------------

  void _proceedToPayment(
      BuildContext context, String selectedPayment, SavedCardEntity? savedCard) {
    Navigator.pushNamed(
      context,
      AppRoutes.paymentProcessing,
      arguments: {
        'order': widget.order,
        'paymentMethod': selectedPayment,
        'savedCard': savedCard,
      },
    );
  }

  void _showAddMoneyDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final addMoneyCubit = AddMoneyCubit();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Add Money to Wallet',
          style: context.ts.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                hintText: 'Enter amount to add',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.currency_rupee),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount =
                  addMoneyCubit.validateAndParseAmount(amountController.text);
              if (amount != null) {
                context.read<WalletBloc>().add(AddMoneyEvent(
                      userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                      amount: amount,
                    ));
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please enter a valid amount')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.cs.primary,
              foregroundColor: context.cs.onPrimary,
            ),
            child: const Text('Add Money'),
          ),
        ],
      ),
    );
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PaymentSelectionCubit(
            getSavedCardsUseCase: sl<GetSavedCardsUseCase>(),
          )..loadSavedCards(userId),
        ),
        BlocProvider(
          create: (context) =>
              sl<WalletBloc>()..add(LoadWalletDataEvent(userId)),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Payment Method'),
          elevation: 0,
        ),
        body: BlocBuilder<PaymentSelectionCubit, PaymentSelectionState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- Order Summary ----------------
                  PaymentSelectionOrderSummary(
                    totalCost: widget.order.totalCost,
                  ),
                  32.h,

                  // ---------------- Saved Cards Section ----------------
                  if (state.savedCards.isNotEmpty) ...[
                    Text(
                      'Saved Cards',
                      style: context.ts.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    16.h,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.savedCards.length,
                      itemBuilder: (context, index) {
                        final card = state.savedCards[index];
                        final isSelected =
                            state.selectedPayment == 'saved_card' &&
                                state.selectedSavedCard == card;

                        return UserCardWidget(
                          card: card,
                          isSelected: isSelected,
                          onTap: () {
                            context
                                .read<PaymentSelectionCubit>()
                                .selectSavedCard(card);
                          },
                        );
                      },
                    ),
                    32.h,
                  ],

                  // ---------------- Other Payment Methods ----------------
                  Text(
                    'Other Payment Methods',
                    style: context.ts.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  16.h,
                  PaymentOptionCard(
                    title: 'My Wallet',
                    subtitle: 'Use your wallet balance',
                    description: 'Fast and secure payment',
                    value: 'wallet',
                    icon: Icons.account_balance_wallet,
                    totalCost: widget.order.totalCost,
                    onAddMoney: () => _showAddMoneyDialog(context),
                  ),
                  16.h,
                  PaymentOptionCard(
                    title: 'Cash on Delivery',
                    subtitle: 'Pay when you receive your order',
                    description: 'No upfront payment required',
                    value: 'cod',
                    icon: Icons.money,
                    totalCost: widget.order.totalCost,
                  ),
                  16.h,
                  PaymentOptionCard(
                    title: 'Stripe',
                    subtitle: 'Secure online payment',
                    description: 'Enter card details safely',
                    value: 'stripe',
                    icon: Icons.credit_card,
                    totalCost: widget.order.totalCost,
                  ),
                  32.h,

                  // ---------------- Continue Button ----------------
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: MainButton(
                      label: state.isLoading
                          ? 'Processing...'
                          : 'Continue to Payment',
                      onPress: !state.isLoading &&
                              state.selectedPayment.isNotEmpty
                          ? () => _proceedToPayment(context,
                              state.selectedPayment, state.selectedSavedCard)
                          : null,
                      color: context.cs.success,
                      textColor: context.cs.surface,
                    ),
                  ),
                  16.h,

                  // ---------------- Payment Info Banner ----------------
                  const PaymentInfoBanner(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}