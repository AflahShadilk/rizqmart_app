import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/di/register.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:rizqmart/features/presentation/bloc/wallet/wallet_event.dart';
import 'package:rizqmart/features/presentation/bloc/wallet/wallet_state.dart';
import 'package:rizqmart/features/presentation/widgets/extensions/sized_box.dart';

// ---------------- Withdraw Screen ----------------

/// A screen allowing users to specify an amount and submit a request to withdraw
/// funds from their wallet.
class WithdrawScreen extends StatefulWidget {
  final String userId;

  const WithdrawScreen({super.key, required this.userId});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {

  // ---------------- Controllers ----------------

  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // ---------------- Dispose ----------------

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  // ---------------- Helper Methods ----------------

  void _submitWithdrawal(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);
      context.read<WalletBloc>().add(
            RequestWithdrawalEvent(
              userId: widget.userId,
              amount: amount,
            ),
          );
    }
  }

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<WalletBloc>()..add(LoadWalletDataEvent(widget.userId)),
      child: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: context.cs.success,
              ),
            );
            Navigator.pop(context);
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: context.cs.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Withdraw Funds'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------- Amount Input Section ----------------
                    Text(
                      'Enter Amount to Withdraw',
                      style: context.ts.titleMedium,
                    ),
                    8.h,
                    TextFormField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                        prefixText: '₹ ',
                        border: OutlineInputBorder(),
                        hintText: '0.00',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null || amount <= 0) {
                          return 'Please enter a valid amount';
                        }
                        if (state.wallet != null &&
                            amount > state.wallet!.balance) {
                          return 'Insufficient balance (Max: ₹${state.wallet!.balance.toStringAsFixed(2)})';
                        }
                        return null;
                      },
                    ),
                    16.h,

                    // ---------------- Available Balance Info ----------------
                    if (state.wallet != null)
                      Text(
                        'Available Balance: ₹${state.wallet!.balance.toStringAsFixed(2)}',
                        style: context.ts.bodySmall?.copyWith(
                          color: context.cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    const Spacer(),

                    // ---------------- Submit Button ----------------
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.status == WalletStatus.loading
                            ? null
                            : () => _submitWithdrawal(context),
                        style: ElevatedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: context.cs.primary,
                          foregroundColor: context.cs.onPrimary,
                        ),
                        child: state.status == WalletStatus.loading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: context.cs.onPrimary,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Submit Request'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}