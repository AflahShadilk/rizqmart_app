

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_state.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/cubits/payment/add_money_cubit.dart';
import 'withdraw_screen.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

class WalletScreen extends StatelessWidget {
  final String userId;
  const WalletScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WalletBloc>()..add(LoadWalletDataEvent(userId)),
      child: Scaffold(
        backgroundColor: context.cs.surface,
        appBar: AppBar(
          title: Text(
            'My Wallet',
            style: context.ts.headlineMedium,
          ),
          backgroundColor: context.cs.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: context.cs.onSurface),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            if (state.status == WalletStatus.loading && state.wallet == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<WalletBloc>().add(LoadWalletDataEvent(userId));
              },
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [context.cs.primary, context.cs.primary.withValues(alpha: 0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: context.cs.primary.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Balance',
                          style: context.ts.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        8.h,
                        Text(
                          '₹ ${(state.wallet?.balance ?? 0.0).toStringAsFixed(2)}',
                          style: context.ts.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        24.h,
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WithdrawScreen(userId: userId),
                                    ),
                                  ).then((_) {
                                    
                                    context.read<WalletBloc>().add(LoadWalletDataEvent(userId));
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: context.cs.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Withdraw', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            12.w,
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _showAddMoneyDialog(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                child: const Text('Add Money', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  24.h,

                  
                  Text(
                    'Transaction History',
                    style: context.ts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  12.h,

                  
                  if (state.transactions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text(
                          'No transactions yet',
                          style: context.ts.bodyMedium?.copyWith(
                            color: context.cs.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    )
                  else
                    ...state.transactions.map((transaction) {
                      final isCredit = transaction.type == TransactionType.refund || 
                                     transaction.type == TransactionType.deposit;
                      
                      return Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: context.cs.outline.withValues(alpha: 0.1)),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isCredit 
                                ? Colors.green.withValues(alpha: 0.1) 
                                : Colors.red.withValues(alpha: 0.1),
                            child: Icon(
                              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                              color: isCredit ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(
                            transaction.description,
                            style: context.ts.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            _formatDate(transaction.timestamp),
                            style: context.ts.bodySmall,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${isCredit ? "+" : "-"} ₹${transaction.amount.toStringAsFixed(2)}',
                                style: context.ts.bodyLarge?.copyWith(
                                  color: isCredit ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (transaction.status != TransactionStatus.completed)
                                Text(
                                  transaction.status.name.toUpperCase(),
                                  style: context.ts.labelSmall?.copyWith(
                                    fontSize: 10,
                                    color: Colors.orange,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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
                  userId: userId,
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