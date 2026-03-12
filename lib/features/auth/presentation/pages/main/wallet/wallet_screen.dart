// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/core/services/registeration/register.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/wallet/wallet_state.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wallet/withdraw_screen.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wallet/widgets/wallet_balance_card.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wallet/widgets/wallet_transaction_list.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Wallet Screen ----------------

/// A screen displaying the user's current wallet balance, recent transactions,
/// and options to add or withdraw funds.
class WalletScreen extends StatelessWidget {

  // ---------------- Variables ----------------

  final String userId;

  const WalletScreen({super.key, required this.userId});

  // ---------------- Helper Methods ----------------

  void _navigateToWithdraw(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WithdrawScreen(userId: userId),
      ),
    ).then((_) {
      context.read<WalletBloc>().add(LoadWalletDataEvent(userId));
    });
  }

  // ---------------- Build Method ----------------

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
                  // ---------------- Wallet Balance Card ----------------
                  WalletBalanceCard(
                    balance: state.wallet?.balance ?? 0.0,
                    onWithdraw: () => _navigateToWithdraw(context),
                  ),
                  24.h,

                  // ---------------- Transaction History ----------------
                  WalletTransactionList(
                    transactions: state.transactions,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
