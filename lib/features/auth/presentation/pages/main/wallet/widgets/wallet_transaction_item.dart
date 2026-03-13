import 'package:flutter/material.dart';
import 'package:rizqmart/core/theme/color_getter.dart';
import 'package:rizqmart/core/theme/context_theme.dart';
import 'package:rizqmart/features/auth/presentation/widgets/app_date_widget.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';
class WalletTransactionItem extends StatelessWidget {
  final WalletTransactionEntity transaction;

  const WalletTransactionItem({
    super.key,
    required this.transaction,
  });
  bool get _isCredit =>
      transaction.type == TransactionType.refund ||
      transaction.type == TransactionType.deposit;
@override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.cs.outline.withValues(alpha: 0.1),
        ),
      ),
      child: ListTile(
leading: CircleAvatar(
          backgroundColor: _isCredit
              ? context.cs.success.withValues(alpha: 0.1)
              : context.cs.error.withValues(alpha: 0.1),
          child: Icon(
            _isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: _isCredit ? context.cs.success : context.cs.error,
          ),
        ),
title: Text(
          transaction.description,
          style: context.ts.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          AppDateWidget.format(transaction.timestamp),
          style: context.ts.bodySmall?.copyWith(
            color: context.cs.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${_isCredit ? "+" : "-"} ₹${transaction.amount.toStringAsFixed(2)}',
              style: context.ts.bodyLarge?.copyWith(
                color: _isCredit ? context.cs.success : context.cs.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (transaction.status != TransactionStatus.completed)
              Text(
                transaction.status.name.toUpperCase(),
                style: context.ts.labelSmall?.copyWith(
                  fontSize: 10,
                  color: context.cs.tertiary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
