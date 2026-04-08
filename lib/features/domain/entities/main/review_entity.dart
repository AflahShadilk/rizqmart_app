import 'package:equatable/equatable.dart';

/// Entity capturing a user's review and rating for a specific product and variant.
class ReviewEntity extends Equatable {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userImage;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final String? variantName;

  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.variantName,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        userId,
        userName,
        userImage,
        rating,
        comment,
        createdAt,
        variantName,
      ];
}
