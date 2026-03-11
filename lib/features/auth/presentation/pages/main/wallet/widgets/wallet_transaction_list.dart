import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';
import 'package:rizqmart/features/auth/presentation/pages/main/wallet/widgets/wallet_transaction_item.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Wallet Transaction List ----------------

/// Displays a list of wallet transactions or an empty-state message when none exist.
class WalletTransactionList extends StatelessWidget {
  final List<WalletTransactionEntity> transactions;

  const WalletTransactionList({
    super.key,
    required this.transactions,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- Section Title ----------------
        Text(
          'Transaction History',
          style: context.ts.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        12.h,

        // ---------------- Empty State or Transaction Items ----------------
        if (transactions.isEmpty)
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
          ...transactions.map(
            (transaction) => WalletTransactionItem(transaction: transaction),
          ),
      ],
    );
  }
}
