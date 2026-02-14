import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class LoadWalletDataEvent extends WalletEvent {
  final String userId;

  const LoadWalletDataEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class RequestWithdrawalEvent extends WalletEvent {
  final String userId;
  final double amount;

  const RequestWithdrawalEvent({
    required this.userId,
    required this.amount,
  });

  @override
  List<Object?> get props => [userId, amount];
}

class AddMoneyEvent extends WalletEvent {
  final String userId;
  final double amount;

  const AddMoneyEvent({
    required this.userId,
    required this.amount,
  });

  @override
  List<Object?> get props => [userId, amount];
}
