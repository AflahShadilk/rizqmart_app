import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/domain/entities/main/saved_card_entity.dart';

/// State storing lists of saved cards alongside the actively chosen payment option.
class PaymentSelectionState extends Equatable {
  final String selectedPayment;
  final bool isLoading;
  final List<SavedCardEntity> savedCards;
  final SavedCardEntity? selectedSavedCard;
  final String? errorMessage;

  const PaymentSelectionState({
    this.selectedPayment = '',
    this.isLoading = false,
    this.savedCards = const [],
    this.selectedSavedCard,
    this.errorMessage,
  });

  PaymentSelectionState copyWith({
    String? selectedPayment,
    bool? isLoading,
    List<SavedCardEntity>? savedCards,
    SavedCardEntity? selectedSavedCard,
    String? errorMessage,
  }) {
    return PaymentSelectionState(
      selectedPayment: selectedPayment ?? this.selectedPayment,
      isLoading: isLoading ?? this.isLoading,
      savedCards: savedCards ?? this.savedCards,
      selectedSavedCard: selectedSavedCard ?? this.selectedSavedCard,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedPayment,
        isLoading,
        savedCards,
        selectedSavedCard,
        errorMessage,
      ];
}