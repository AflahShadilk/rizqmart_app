import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/extensions/sized_box.dart';

// ---------------- Wallet Balance Card ----------------

/// A gradient card displaying the user's current wallet balance with Withdraw and Add Money action buttons.
class WalletBalanceCard extends StatelessWidget {
  final double balance;
  final VoidCallback onWithdraw;
  final VoidCallback onAddMoney;

  const WalletBalanceCard({
    super.key,
    required this.balance,
    required this.onWithdraw,
    required this.onAddMoney,
  });

  // ---------------- Build Method ----------------

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.cs.primary,
            context.cs.primary.withValues(alpha: 0.8),
          ],
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
          // ---------------- Balance Label ----------------
          Text(
            'Available Balance',
            style: context.ts.bodyLarge?.copyWith(
              color: context.cs.onPrimary.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          8.h,

          // ---------------- Balance Amount ----------------
          Text(
            '₹ ${balance.toStringAsFixed(2)}',
            style: context.ts.displaySmall?.copyWith(
              color: context.cs.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          24.h,

          // ---------------- Action Buttons ----------------
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onWithdraw,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.cs.onPrimary,
                    foregroundColor: context.cs.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Withdraw',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              12.w,
              Expanded(
                child: ElevatedButton(
                  onPressed: onAddMoney,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.cs.onPrimary.withValues(alpha: 0.2),
                    foregroundColor: context.cs.onPrimary,
                    elevation: 0,
                    side: BorderSide(color: context.cs.onPrimary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Add Money',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
