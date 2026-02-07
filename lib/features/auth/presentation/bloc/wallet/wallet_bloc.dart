import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wallet/get_wallet_balance_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wallet/get_wallet_transactions_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wallet/withdraw_wallet_amount_usecase.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletBalanceUseCase getWalletBalance;
  final GetWalletTransactionsUseCase getWalletTransactions;
  final RequestWithdrawalUseCase requestWithdrawal;

  WalletBloc({
    required this.getWalletBalance,
    required this.getWalletTransactions,
    required this.requestWithdrawal,
  }) : super(const WalletState()) {
    on<LoadWalletDataEvent>(_onLoadWalletData);
    on<RequestWithdrawalEvent>(_onWithdraw);
  }

  Future<void> _onLoadWalletData(
    LoadWalletDataEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));
    
    final balanceResult = await getWalletBalance(event.userId);
    final transactionsResult = await getWalletTransactions(event.userId);

    balanceResult.fold(
      (failure) => emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: failure,
      )),
      (wallet) {
        transactionsResult.fold(
          (failure) => emit(state.copyWith(
            status: WalletStatus.loaded,
            wallet: wallet,
            // Keep existing transactions or empty if failed? 
            // Better to show balance even if transactions fail, but let's just log error
            errorMessage: "Failed to load transactions: $failure", 
          )),
          (transactions) => emit(state.copyWith(
            status: WalletStatus.loaded,
            wallet: wallet,
            transactions: transactions,
            errorMessage: null,
          )),
        );
      },
    );
  }

  Future<void> _onWithdraw(
    RequestWithdrawalEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));
    final result = await requestWithdrawal(
      userId: event.userId,
      amount: event.amount,
    );
    
    result.fold(
      (failure) => emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: failure,
      )),
      (transaction) { 
        emit(state.copyWith(
          status: WalletStatus.success,
          successMessage: 'Withdrawal request submitted successfully',
        ));
        add(LoadWalletDataEvent(event.userId)); // Refresh data
      },
    );
  }
}
