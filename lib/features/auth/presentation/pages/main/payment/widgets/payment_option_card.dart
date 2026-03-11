import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/payment_selection_cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/payment_selection_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Payment Option Card ----------------

/// A selectable payment method card supporting Wallet (with balance check), COD, and Stripe options.
class PaymentOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String value;
  final IconData icon;
  final double totalCost;
  final VoidCallback? onAddMoney;

  const PaymentOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.value,
    required this.icon,
    required this.totalCost,
    this.onAddMoney,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    if (value == 'wallet') {
      return _buildWalletOption(context);
    }
    return _buildStandardOption(context);
  }

  // ---------------- Wallet Option ----------------

  Widget _buildWalletOption(BuildContext context) {
    return BlocBuilder<WalletBloc, WalletState>(
      builder: (context, walletState) {
        final balance = walletState.wallet?.balance ?? 0.0;
        final isInsufficient = balance < totalCost;

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
                          : (isInsufficient
                              ? context.cs.onSurface.withValues(alpha: 0.03)
                              : Colors.transparent),
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
                            color: isInsufficient
                                ? context.cs.onSurface.withValues(alpha: 0.4)
                                : context.cs.primary,
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
                                  color: isInsufficient
                                      ? context.cs.onSurface.withValues(alpha: 0.4)
                                      : null,
                                ),
                              ),
                              4.h,
                              Text(
                                'Balance: ₹${balance.toStringAsFixed(2)}',
                                style: context.ts.bodySmall?.copyWith(
                                  color: isInsufficient ? context.cs.error : context.cs.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              8.h,
                              Text(
                                description,
                                style: context.ts.labelSmall?.copyWith(
                                  color: (isInsufficient
                                          ? context.cs.onSurface.withValues(alpha: 0.4)
                                          : context.cs.primary)
                                      .withValues(alpha: 0.7),
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
                        onPressed: onAddMoney,
                        icon: const Icon(Icons.add),
                        label: Text(
                            'Add Money (₹${(totalCost - balance).toStringAsFixed(2)} needed)'),
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

  // ---------------- Standard Option ----------------

  Widget _buildStandardOption(BuildContext context) {
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
                color: isSelected ? context.cs.primary : context.cs.outlineVariant,
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
}
