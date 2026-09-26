import 'package:flutter_test/flutter_test.dart';
import 'package:rizqmart/features/data/data_source/main/cart_data_source.dart';

void main() {
  group('CartDataSource Logic Tests', () {
    late CartDataSource cartDataSource;

    setUp(() {
      cartDataSource = CartDataSource();
    });

    test('cartCollectionReference should return null if userId is empty', () {
      // This verifies our fix for the "document path must be a non-empty string" error
      final result = cartDataSource.cartCollectionReference('');
      expect(result, isNull);
    });

    test('getCartItems should return an empty stream if userId is empty', () async {
      // This verifies that we don't crash when trying to get items without a login
      final stream = cartDataSource.getCartItems('');
      final firstValue = await stream.first;
      expect(firstValue, isEmpty);
    });
  });
}
