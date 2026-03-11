import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/peyment_terms-cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/payment_terms_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Payment Confirmation View ----------------

/// The main confirmation UI showing order summary, selected method, terms, and payment button.
class PaymentConfirmationView extends StatelessWidget {
  final PaymentMethodSelectedState state;

  const PaymentConfirmationView({
    super.key,
    required this.state,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    final isCOD = state.paymentMethod == 'cod';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- Order Summary Card ----------------
          _OrderSummaryCard(order: state.order),
          24.h,

          // ---------------- Payment Method Card ----------------
          _PaymentMethodCard(method: state.paymentMethod),
          24.h,

          // ---------------- Secure Payment Info ----------------
          if (!isCOD) ...[
            _SecurePaymentInfo(),
            24.h,
          ],

          // ---------------- Terms Checkbox ----------------
          _TermsCheckbox(),
          24.h,

          // ---------------- Payment Action Button ----------------
          _PaymentActionButton(state: state, isCOD: isCOD),
          16.h,

          // ---------------- Supported Methods Info ----------------
          if (!isCOD)
            Center(
              child: Text(
                'Supports Cards, UPI, Wallets & Net Banking',
                style: context.ts.bodySmall?.copyWith(
                  color: context.cs.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------- Order Summary Card ----------------

class _OrderSummaryCard extends StatelessWidget {
  final OrderEntities order;

  const _OrderSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.cs.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 20,
                  color: context.cs.primary,
                ),
                8.w,
                Text(
                  'Order Summary',
                  style: context.ts.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            16.h,
            _CostRow(label: 'Subtotal', amount: order.subtotal),
            8.h,
            _CostRow(label: 'Delivery', amount: order.deliveryFee),
            if (order.discount > 0) ...[
              8.h,
              _CostRow(
                  label: 'Discount',
                  amount: -order.discount,
                  isDiscount: true),
            ],
            12.h,
            Divider(color: context.cs.outlineVariant),
            12.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: context.ts.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${order.totalCost.toStringAsFixed(2)}',
                  style: context.ts.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.cs.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Cost Row ----------------

class _CostRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDiscount;

  const _CostRow({
    required this.label,
    required this.amount,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.ts.bodyMedium),
        Text(
          '₹${amount.abs().toStringAsFixed(2)}',
          style: context.ts.bodyMedium?.copyWith(
            color: isDiscount ? context.cs.success : context.cs.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ---------------- Payment Method Card ----------------

class _PaymentMethodCard extends StatelessWidget {
  final String method;

  const _PaymentMethodCard({required this.method});

  @override
  Widget build(BuildContext context) {
    final isCOD = method == 'cod';
    final icon = isCOD ? Icons.money : Icons.credit_card;
    final title = isCOD ? 'Cash on Delivery' : 'Stripe Payment';
    final subtitle = isCOD ? 'Pay when you receive' : 'Secure payment via Stripe';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.cs.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.cs.primary.withValues(alpha: 0.1),
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
                    'Payment Method',
                    style: context.ts.labelSmall?.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  4.h,
                  Text(
                    title,
                    style: context.ts.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  2.h,
                  Text(
                    subtitle,
                    style: context.ts.bodySmall?.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Secure Payment Info ----------------

class _SecurePaymentInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cs.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lock_outline,
            color: context.cs.primary,
            size: 24,
          ),
          12.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Secure Payment',
                  style: context.ts.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.cs.primary,
                  ),
                ),
                4.h,
                Text(
                  'Your payment is processed securely via Stripe',
                  style: context.ts.bodySmall?.copyWith(
                    color: context.cs.onSurface.withValues(alpha: 0.7),
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

// ---------------- Terms Checkbox ----------------

class _TermsCheckbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentTermsCubit, PaymentTermsState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.termsAccepted,
              onChanged: (value) {
                context
                    .read<PaymentTermsCubit>()
                    .toggleTerms(value ?? false);
              },
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: 'I agree to the ',
                  style: context.ts.bodySmall?.copyWith(
                    color: context.cs.onSurface,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: context.ts.bodySmall?.copyWith(
                        color: context.cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ---------------- Payment Action Button ----------------

class _PaymentActionButton extends StatelessWidget {
  final PaymentMethodSelectedState state;
  final bool isCOD;

  const _PaymentActionButton({
    required this.state,
    required this.isCOD,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentTermsCubit, PaymentTermsState>(
      builder: (context, termsState) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: MainButton(
            label: isCOD
                ? 'Place Order  ₹${state.order.totalCost.toStringAsFixed(2)}'
                : 'Pay ₹${state.order.totalCost.toStringAsFixed(2)}',
            onPress: termsState.termsAccepted
                ? () {
                    if (context.mounted) {
                      context.read<PaymentBloc>().add(
                            ProcessPaymentEvent(state.paymentMethod),
                          );
                    }
                  }
                : null,
            color: context.cs.success,
            textColor: context.cs.surface,
          ),
        );
      },
    );
  }
}
