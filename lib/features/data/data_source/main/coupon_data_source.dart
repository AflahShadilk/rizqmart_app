import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/data/model/main/coupon_model.dart';

/// Interface defining operations for fetching promotional coupons.
abstract class CouponDataSource {
  Future<List<CouponModel>> getActiveCoupons();
}

/// Firestore implementation for retrieving active and valid promotional coupons.
class CouponDataSourceImpl implements CouponDataSource {
  final FirebaseFirestore firestore;

  CouponDataSourceImpl({required this.firestore});

  @override
  Future<List<CouponModel>> getActiveCoupons() async {
    final querySnapshot = await firestore
        .collection('coupons')
        .where('isActive', isEqualTo: true)
        .get();

    return querySnapshot.docs
        .map((doc) => CouponModel.fromMap(doc.data(), doc.id))
        .where((coupon) => coupon.expiryDate.isAfter(DateTime.now()))
        .toList();
  }
}
