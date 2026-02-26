

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rizqmart/features/auth/data/model/main/explore_model.dart';

/// Remote data source facilitating search, categorization, and retrieval of product catalogs for the explore section.
class ExploreDataSources {
  final FirebaseFirestore store = FirebaseFirestore.instance;
  Stream<List<ExploreModel>> getAllProducts() {
    try {
      return store
          .collection('products')
          .snapshots()
          .map((snap) => snap.docs.map((doc) {
                return ExploreModel.fromFireStore(doc);
              }).toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ExploreModel>> getProductbyCategory(String categroy) {
    try {
      return store
          .collection('products')
          .where('category', isEqualTo: categroy)
          .snapshots()
          .map((snap) => snap.docs.map((doc) {
                return ExploreModel.fromFireStore(doc);
              }).toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ExploreModel>> searchProducts(String produtct) {
    try {
      return store
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: produtct)
          .where('name', isLessThan: '${produtct}z')
          .snapshots()
          .map((snap) => snap.docs.map((doc) {
                return ExploreModel.fromFireStore(doc);
              }).toList());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<CategoryModel>> getCategories() {
    try {
      return store
          .collection('categories')
          .snapshots()
          .map((snap) => snap.docs.map((doc) {
                return CategoryModel.fromFireStore(doc);
              }).toList());
    } catch (e) {
      rethrow;
    }
  }
}
