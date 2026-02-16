import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wallet/get_wallet_balance_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wallet/get_wallet_transactions_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wallet/withdraw_wallet_amount_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wallet/credit_wallet_usecase.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wallet_transaction_entity.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWalletBalanceUseCase getWalletBalance;
  final GetWalletTransactionsUseCase getWalletTransactions;
  final RequestWithdrawalUseCase requestWithdrawal;
  final CreditWalletUseCase creditWalletUseCase;

  WalletBloc({
    required this.getWalletBalance,
    required this.getWalletTransactions,
    required this.requestWithdrawal,
    required this.creditWalletUseCase,
  }) : super(const WalletState()) {
    on<LoadWalletDataEvent>(_onLoadWalletData);
    on<RequestWithdrawalEvent>(_onWithdraw);
    on<AddMoneyEvent>(_onAddMoney);
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
        add(LoadWalletDataEvent(event.userId)); 
      },
    );
  }

  Future<void> _onAddMoney(
    AddMoneyEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));
    
    
    final referenceId = 'dep_${DateTime.now().millisecondsSinceEpoch}';
    
    final result = await creditWalletUseCase(
      userId: event.userId,
      amount: event.amount,
      description: 'Wallet Top-up',
      referenceId: referenceId,
      type: TransactionType.deposit,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: failure,
      )),
      (transaction) {
        emit(state.copyWith(
          status: WalletStatus.success,
          successMessage: '₹${event.amount} added to wallet successfully',
        ));
        add(LoadWalletDataEvent(event.userId)); 
      },
    );
  }
}
