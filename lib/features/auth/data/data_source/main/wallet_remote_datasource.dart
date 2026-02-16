import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/data/model/main/wallet_model.dart';
import 'package:rizqmart/features/auth/data/model/main/wallet_transaction_model.dart';

abstract class WalletRemoteDataSource {
  Future<WalletModel> getWallet(String userId);
  Stream<WalletModel> getWalletStream(String userId);
  Future<void> updateWalletBalance(String userId, double newBalance);
  Future<void> addTransaction(WalletTransactionModel transaction);
  Future<List<WalletTransactionModel>> getTransactions(String userId);

  
  Future<void> performWalletTransaction({
    required String userId,
    required double newBalance,
    required WalletTransactionModel transaction,
  });
}

class WalletRemoteDataSourceImpl implements WalletRemoteDataSource {
  final FirebaseFirestore firestore;

  WalletRemoteDataSourceImpl(this.firestore);

  @override
  Future<WalletModel> getWallet(String userId) async {
    final doc = await firestore.collection('wallets').doc(userId).get();
    if (doc.exists) {
      return WalletModel.fromMap(doc.data()!, doc.id);
    } else {
      
      final newWallet = WalletModel(
        userId: userId,
        balance: 0.0,
        currency: 'INR',
        lastUpdated: DateTime.now(),
      );
      await firestore.collection('wallets').doc(userId).set(newWallet.toMap());
      return newWallet;
    }
  }

  @override
  Stream<WalletModel> getWalletStream(String userId) {
    return firestore.collection('wallets').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return WalletModel.fromMap(doc.data()!, doc.id);
      } else {
         return WalletModel(
          userId: userId,
          balance: 0.0,
          currency: 'INR',
          lastUpdated: DateTime.now(),
        );
      }
    });
  }

  @override
  Future<void> updateWalletBalance(String userId, double newBalance) async {
    await firestore.collection('wallets').doc(userId).update({
      'balance': newBalance,
      'lastUpdated': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> addTransaction(WalletTransactionModel transaction) async {
    
    await firestore
        .collection('wallets')
        .doc(transaction.walletId)
        .collection('transactions')
        .add(transaction.toMap());
  }

  @override
  Future<List<WalletTransactionModel>> getTransactions(String userId) async {
    final query = await firestore
        .collection('wallets')
        .doc(userId)
        .collection('transactions')
        .orderBy('timestamp', descending: true)
        .get();

    return query.docs
        .map((doc) => WalletTransactionModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> performWalletTransaction({
    required String userId,
    required double newBalance,
    required WalletTransactionModel transaction,
  }) async {
    final walletRef = firestore.collection('wallets').doc(userId);
    final transactionRef = walletRef.collection('transactions').doc();

    await firestore.runTransaction((firestoreTransaction) async {
      firestoreTransaction.update(walletRef, {
        'balance': newBalance,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      
      
      
      firestoreTransaction.set(transactionRef, transaction.toMap());
    });
  }
}
