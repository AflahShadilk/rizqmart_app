import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/data/model/main/saved_card_model.dart';
import 'package:rizqmart/features/auth/domain/entities/main/saved_card_entity.dart';

/// Remote data source for securely managing a user's saved payment methods in Firestore.
class SavedCardRemoteDataSource {
  final FirebaseFirestore firestore;

  SavedCardRemoteDataSource(this.firestore);

  Future<void> addSavedCard(SavedCardEntity card, String userId) async {
    final model = SavedCardModel(
      id: '', 
      paymentMethodId: card.paymentMethodId,
      last4: card.last4,
      brand: card.brand,
      expiryMonth: card.expiryMonth,
      expiryYear: card.expiryYear,
      cardHolderName: card.cardHolderName,
      cardColor: card.cardColor,
    );

    await firestore
        .collection('users')
        .doc(userId)
        .collection('saved_cards')
        .add(model.toJson());
  }

  Future<List<SavedCardModel>> getSavedCards(String userId) async {
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('saved_cards')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => SavedCardModel.fromFirestore(doc))
        .toList();
  }

  Future<void> deleteSavedCard(String cardId, String userId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('saved_cards')
        .doc(cardId)
        .delete();
  }
}
