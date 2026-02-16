

// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/routes/app_routes.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/peyment_terms-cubit.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/payment/payment_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/payment_terms_state.dart';
import 'package:rizqmart/features/auth/presentation/widgets/buttons/reusable_main_button.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class PaymentProcessingPage extends StatefulWidget {
  final OrderEntities order;
  final String paymentMethod;
  final SavedCardEntity? savedCard;

  const PaymentProcessingPage({
    super.key,
    required this.order,
    required this.paymentMethod,
    this.savedCard,
  });

  @override
  State<PaymentProcessingPage> createState() => _PaymentProcessingPageState();
}

class _PaymentProcessingPageState extends State<PaymentProcessingPage> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  void _initializePayment() {
    if (!_isInitialized) {
      _isInitialized = true;
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          context.read<PaymentBloc>().add(
            InitializePaymentEvent(
              order: widget.order,
              paymentMethod: widget.paymentMethod,
              savedCard: widget.savedCard,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PaymentTermsCubit(),
        ),
      ],
      child: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccessState) {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.orderSuccess,
              arguments: widget.order.items,
            );
          } else if (state is PaymentFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: context.cs.error,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Complete Payment'),
            centerTitle: true,
            elevation: 0,
            leading: BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                final isProcessing = state is PaymentLoadingState;
                return IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: isProcessing ? null : () => Navigator.pop(context),
                );
              },
            ),
          ),
          body: BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, state) {
              if (state is PaymentLoadingState) {
                return _buildLoading(context, state.message);
              } else if (state is PaymentMethodSelectedState) {
                return _buildPaymentConfirmation(context, state);
              } else if (state is PaymentSuccessState) {
                return _buildSuccess(context, state);
              } else if (state is PaymentFailedState) {
                return _buildError(context, state.message);
              }
              return Center(
                child: CircularProgressIndicator(color: context.cs.primary),
              );
            },
          ),
        ),
      ),
    );
  }


  Widget _buildLoading(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: context.cs.primary,
            strokeWidth: 3,
          ),
          16.h,
          Text(
            message,
            style: context.ts.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          8.h,
          Text(
            'Please do not close this screen',
            style: context.ts.bodySmall?.copyWith(
              color: context.cs.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentConfirmation(
    BuildContext context,
    PaymentMethodSelectedState state,
  ) {
    final isCOD = state.paymentMethod == 'cod';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderSummaryCard(context, state.order),
          24.h,
          _buildPaymentMethodCard(context, state.paymentMethod),
          24.h,
          if (!isCOD) ...[
            _buildSecurePaymentInfo(context),
            24.h,
          ],
          _buildTermsCheckbox(context),
          24.h,
          _buildPaymentButton(context, state, isCOD),
          16.h,
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

  Widget _buildPaymentButton(
    BuildContext context,
    PaymentMethodSelectedState state,
    bool isCOD,
  ) {
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
                ? () => _handlePaymentButtonPress(context, state, isCOD)
                : null,
            color: context.cs.success,
            textColor: context.cs.surface,
          ),
        );
      },
    );
  }

  Future<void> _handlePaymentButtonPress(
  BuildContext context,
  PaymentMethodSelectedState state,
  bool isCOD,
) async {
  
  if (context.mounted) {
    context.read<PaymentBloc>().add(
      ProcessPaymentEvent(state.paymentMethod),
    );
  }
}

  
  
  
  
  
  
  

  
  
  
  
  
  

  
  

  
  
  

  
  

  
  
  
  
  

  

  
  
  

  
  

  
  

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
  
  
  

  

  
  
  
  
  
  
  
  
  

  Widget _buildSuccess(
    BuildContext context,
    PaymentSuccessState state,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.cs.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: context.cs.success,
              ),
            ),
            24.h,
            Text(
              'Payment Successful!',
              style: context.ts.headlineSmall?.copyWith(
                color: context.cs.success,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.h,
            Text(
              'Your order has been placed',
              style: context.ts.bodyMedium?.copyWith(
                color: context.cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
            16.h,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.cs.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: context.cs.outlineVariant,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Order ID',
                    style: context.ts.labelSmall?.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  4.h,
                  Text(
                    state.orderId,
                    style: context.ts.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
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

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.cs.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 80,
                  color: context.cs.error,
                ),
              ),
              24.h,
              Text(
                'Payment Failed',
                style: context.ts.headlineSmall?.copyWith(
                  color: context.cs.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.h,
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.cs.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.cs.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: context.ts.bodyMedium,
                ),
              ),
              24.h,
              SizedBox(
                width: double.infinity,
                height: 56,
                child: MainButton(
                  label: 'Try Again',
                  onPress: () {
                   
                    if (context.mounted) {
                      context.read<PaymentBloc>().add(
                        InitializePaymentEvent(
                          order: widget.order,
                          paymentMethod: widget.paymentMethod,
                          savedCard: widget.savedCard,
                        ),
                      );
                    }
                  },
                  color: context.cs.primary,
                  textColor: context.cs.surface,
                ),
              ),
              12.h,
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil(
                    (route) => route.isFirst,
                  );
                },
                child: Text(
                  'Go to Home',
                  style: context.ts.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildOrderSummaryCard(BuildContext context, OrderEntities order) {
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
            _costRow(context, 'Subtotal', order.subtotal),
            8.h,
            _costRow(context, 'Delivery', order.deliveryFee),
            if (order.discount > 0) ...[
              8.h,
              _costRow(context, 'Discount', -order.discount, isDiscount: true),
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

  Widget _buildPaymentMethodCard(BuildContext context, String method) {
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

  Widget _buildSecurePaymentInfo(BuildContext context) {
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

  Widget _buildTermsCheckbox(BuildContext context) {
    return BlocBuilder<PaymentTermsCubit, PaymentTermsState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.termsAccepted,
              onChanged: (value) {
                context.read<PaymentTermsCubit>().toggleTerms(value ?? false);
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


  
  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: context.cs.primary),
              16.h,
              Text(
                message,
                style: context.ts.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _costRow(
    BuildContext context,
    String label,
    double amount, {
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.ts.bodyMedium,
        ),
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