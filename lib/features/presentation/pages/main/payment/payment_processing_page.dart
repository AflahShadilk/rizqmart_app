import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/presentation/routes/app_routes.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/domain/entities/main/order_entities.dart';
import 'package:rizqmart/features/domain/entities/main/saved_card_entity.dart';
import 'package:rizqmart/features/presentation/cubits/payment/peyment_terms-cubit.dart';
import 'package:rizqmart/features/presentation/bloc/main/payment/payment_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/main/payment/payment_event.dart';
import 'package:rizqmart/features/presentation/bloc/main/payment/payment_state.dart';
import 'package:rizqmart/features/presentation/pages/main/payment/widgets/payment_processing_loading_state.dart';
import 'package:rizqmart/features/presentation/pages/main/payment/widgets/payment_success_state.dart' as success_widget;
import 'package:rizqmart/features/presentation/pages/main/payment/widgets/payment_error_state.dart' as error_widget;
import 'package:rizqmart/features/presentation/pages/main/payment/widgets/payment_confirmation_view.dart';

// ---------------- Payment Processing Page ----------------

/// A page that handles the processing state and outcome of an order payment.
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

  // ---------------- Variables ----------------

  bool _isInitialized = false;

  // ---------------- Init State ----------------

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  // ---------------- Helper Methods ----------------

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

  void _retryPayment() {
    if (context.mounted) {
      context.read<PaymentBloc>().add(
            InitializePaymentEvent(
              order: widget.order,
              paymentMethod: widget.paymentMethod,
              savedCard: widget.savedCard,
            ),
          );
    }
  }

  void _goHome() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  // ---------------- Build Method ----------------

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
                  onPressed:
                      isProcessing ? null : () => Navigator.pop(context),
                );
              },
            ),
          ),
          body: BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, state) {
              // ---------------- Loading State ----------------
              if (state is PaymentLoadingState) {
                return PaymentProcessingLoadingState(message: state.message);
              }

              // ---------------- Confirmation State ----------------
              if (state is PaymentMethodSelectedState) {
                return PaymentConfirmationView(state: state);
              }

              // ---------------- Success State ----------------
              if (state is PaymentSuccessState) {
                return success_widget.PaymentSuccessState(
                    orderId: state.orderId);
              }

              // ---------------- Error State ----------------
              if (state is PaymentFailedState) {
                return error_widget.PaymentErrorState(
                  message: state.message,
                  onRetry: _retryPayment,
                  onGoHome: _goHome,
                );
              }

              // ---------------- Default State ----------------
              return Center(
                child: CircularProgressIndicator(color: context.cs.primary),
              );
            },
          ),
        ),
      ),
    );
  }
}