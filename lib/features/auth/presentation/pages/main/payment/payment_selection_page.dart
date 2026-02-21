

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
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/payment/get_saved_cards_usecase.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/profile/payment/widgets/user_card_widget.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

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
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PaymentSelectionCubit(
            getSavedCardsUseCase: sl<GetSavedCardsUseCase>(),
          )..loadSavedCards(userId),
        ),
        BlocProvider(
          create: (context) => sl<WalletBloc>()..add(LoadWalletDataEvent(userId)),
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
                  buildOrderSummary(context),
                  32.h,
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
                        final isSelected = state.selectedPayment == 'saved_card' &&
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
                  Text(
                    'Other Payment Methods',
                    style: context.ts.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  16.h,
                  buildPaymentOption(
                    context,
                    title: 'My Wallet',
                    subtitle: 'Use your wallet balance',
                    description: 'Fast and secure payment',
                    value: 'wallet',
                    icon: Icons.account_balance_wallet,
                  ),
                  16.h,
                  buildPaymentOption(
                    context,
                    title: 'Cash on Delivery',
                    subtitle: 'Pay when you receive your order',
                    description: 'No upfront payment required',
                    value: 'cod',
                    icon: Icons.money,
                  ),
                  16.h,
                  buildPaymentOption(
                    context,
                    title: 'Stripe',
                    subtitle: 'Secure online payment',
                    description: 'Enter card details safely',
                    value: 'stripe',
                    icon: Icons.credit_card,
                  ),
                  32.h,
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: MainButton(
                      label: state.isLoading
                          ? 'Processing...'
                          : 'Continue to Payment',
                      onPress: !state.isLoading &&
                              state.selectedPayment.isNotEmpty
                          ? () => proceedToPayment(
                              context, state.selectedPayment, state.selectedSavedCard)
                          : null,
                      color: context.cs.success,
                      textColor: context.cs.surface,
                    ),
                  ),
                  16.h,
                  buildPaymentInfo(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildOrderSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cs.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: context.ts.bodySmall?.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
          8.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: context.ts.bodyMedium,
              ),
              Text(
                '₹${widget.order.totalCost.toStringAsFixed(2)}',
                style: context.ts.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.cs.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPaymentOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required String value,
    required IconData icon,
  }) {
    if (value == 'wallet') {
      return BlocBuilder<WalletBloc, WalletState>(
        builder: (context, walletState) {
          final balance = walletState.wallet?.balance ?? 0.0;
          final isInsufficient = balance < widget.order.totalCost;
          
          return BlocBuilder<PaymentSelectionCubit, PaymentSelectionState>(
            builder: (context, state) {
              final isSelected = state.selectedPayment == value;

              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (!isInsufficient) {
                        context.read<PaymentSelectionCubit>().selectPayment(value);
                      } else {
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Insufficient wallet balance')),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? context.cs.primary : context.cs.outlineVariant,
                          width: isSelected ? 2 : 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: isSelected
                            ? context.cs.primary.withValues(alpha: 0.08)
                            : (isInsufficient ? Colors.grey.withValues(alpha: 0.05) : Colors.transparent),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? context.cs.primary.withValues(alpha: 0.15)
                                  : context.cs.outlineVariant.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              icon,
                              color: isInsufficient ? Colors.grey : context.cs.primary,
                              size: 28,
                            ),
                          ),
                          16.w,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: context.ts.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isInsufficient ? Colors.grey : null
                                  ),
                                ),
                                4.h,
                                Text(
                                  'Balance: ₹${balance.toStringAsFixed(2)}',
                                  style: context.ts.bodySmall?.copyWith(
                                    color: isInsufficient ? context.cs.error : context.cs.primary,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                8.h,
                                Text(
                                  description,
                                  style: context.ts.labelSmall?.copyWith(
                                    color: (isInsufficient ? Colors.grey : context.cs.primary).withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!isInsufficient)
                            Radio<String>(
                              value: value,
                              groupValue: state.selectedPayment,
                              onChanged: (val) {
                                if (val != null) {
                                  context.read<PaymentSelectionCubit>().selectPayment(val);
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (isInsufficient)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showAddMoneyDialog(context),
                          icon: const Icon(Icons.add),
                          label: Text('Add Money (₹${(widget.order.totalCost - balance).toStringAsFixed(2)} needed)'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.cs.primary,
                            side: BorderSide(color: context.cs.primary),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      );
    }

    return BlocBuilder<PaymentSelectionCubit, PaymentSelectionState>(
      builder: (context, state) {
        final isSelected = state.selectedPayment == value;

        return InkWell(
          onTap: () {
            context.read<PaymentSelectionCubit>().selectPayment(value);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    isSelected ? context.cs.primary : context.cs.outlineVariant,
                width: isSelected ? 2 : 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isSelected
                  ? context.cs.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.cs.primary.withValues(alpha: 0.15)
                        : context.cs.outlineVariant.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: context.cs.primary,
                    size: 28,
                  ),
                ),
                16.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.ts.bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      4.h,
                      Text(
                        subtitle,
                        style: context.ts.bodySmall?.copyWith(
                          color: context.cs.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      8.h,
                      Text(
                        description,
                        style: context.ts.labelSmall?.copyWith(
                          color: context.cs.primary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<String>(
                  value: value,
                  groupValue: state.selectedPayment,
                  onChanged: (val) {
                    if (val != null) {
                      context.read<PaymentSelectionCubit>().selectPayment(val);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPaymentInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.cs.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.cs.primary,
            size: 20,
          ),
          12.w,
          Expanded(
            child: Text(
              'You can change payment method during checkout',
              style: context.ts.bodySmall?.copyWith(
                color: context.cs.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void proceedToPayment(BuildContext context, String selectedPayment, SavedCardEntity? savedCard) {
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
              final amount = addMoneyCubit.validateAndParseAmount(amountController.text);
              if (amount != null) {
                context.read<WalletBloc>().add(AddMoneyEvent(
                  userId: FirebaseAuth.instance.currentUser?.uid ?? '',
                  amount: amount,
                ));
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.cs.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Money'),
          ),
        ],
      ),
    );
  }
}