import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/show_product_entities.dart';
class CartEntities extends Equatable implements ShowProductEntities{
 @override final String id;
@override  final String name;
  @override
  final String brand;
  @override
  final String? description;
 @override final List<Map<String,dynamic>>variantDetails;
  final int count;
  final int variantIndex;
  final String userId;
  @override
  final double? discount;

  @override final double rating;
  @override final int reviewCount;

  const CartEntities({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.variantDetails,
    required this.count,
    required this.variantIndex,
    required this.userId,
    this.discount,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        description,
        variantDetails,
        count,
        variantIndex,
        userId,
        discount,
        rating,
        reviewCount,
      ];
}