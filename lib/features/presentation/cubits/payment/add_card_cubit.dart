
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:rizqmart/features/domain/entities/main/saved_card_entity.dart';
import 'add_card_state.dart';

/// Cubit coordinating the communication with Stripe to save a new payment card.
class AddCardCubit extends Cubit<AddCardState> {
  AddCardCubit() : super(AddCardInitial());

  Future<void> saveCard({required String name, required String userId}) async {
    emit(AddCardLoading());
    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(),
          ),
        ),
      );

      final cardEntity = SavedCardEntity(
        id: '', 
        paymentMethodId: paymentMethod.id,
        last4: paymentMethod.card.last4 ?? '0000',
        brand: paymentMethod.card.brand ?? 'Unknown',
        expiryMonth: paymentMethod.card.expMonth ?? 0,
        expiryYear: paymentMethod.card.expYear ?? 0,
        cardHolderName: name,
        cardColor: _generateRandomColor(),
      );

      emit(AddCardSuccess(cardEntity));
    } catch (e) {
      emit(AddCardFailure(e.toString()));
    }
  }

  int _generateRandomColor() {
    final colors = [
      0xFF1A1F71, 
      0xFFEB001B, 
      0xFF006FCF, 
      0xFF2C3E50, 
      0xFF8E44AD, 
      0xFF27AE60, 
    ];
    return colors[Random().nextInt(colors.length)];
  }
}
