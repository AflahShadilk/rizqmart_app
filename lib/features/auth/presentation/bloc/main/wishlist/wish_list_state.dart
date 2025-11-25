  import 'package:equatable/equatable.dart';
  import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';

  abstract class WishListState extends Equatable{
    @override
    
    List<Object?> get props => [];
  }

  class InitializeWishListState extends WishListState{
    final List< WishListEntities> item;
    InitializeWishListState(this.item);
@override
    
    List<Object?> get props => [item];
  }

  class LoadingWishListState extends WishListState{}

  class LoadedWishListState extends WishListState{
    final List< WishListEntities> items;
    LoadedWishListState(this.items);
    @override
    List<Object?> get props => [items];
  }

  class FailureWishListState extends WishListState{
    final String message;
    FailureWishListState(this.message);
    @override
    List<Object?> get props => [message];
  }