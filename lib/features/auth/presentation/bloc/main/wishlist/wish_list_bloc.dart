import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/domain/entities/main/wish_list_entities.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wishlist/add_to_wish_list_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wishlist/delete_frm_wish_list_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wishlist/get_all_wish_list_usecase.dart';
import 'package:rizqmart/features/auth/domain/usecase/main/wishlist/wish_list_toggle_usecase.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/wishlist/wish_list_state.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  final AddToWishListUsecase addToWishListUsecase;
  final DeleteFrmWishListUsecase deleteFrmWishListUsecase;
  final GetAllWishListUsecase getAllWishListUsecase;
  final WishListToggleUsecase wishListToggleUsecase;

  WishListBloc({
    required this.addToWishListUsecase,
    required this.deleteFrmWishListUsecase,
    required this.getAllWishListUsecase,
    required this.wishListToggleUsecase,
  }) : super(InitializeWishListState([])) {
    on<ToggleWishListEvent>(onToggleEvent);
    on<GetAllWishListEvent>(onGetAllWishEvent);
    on<AddtoWishListEvent>(onAddtoWishList);
    on<DeleteWishListEvent>(onDeleteWishList);
  }

  Future<void> onToggleEvent(
      ToggleWishListEvent event, Emitter<WishListState> emit) async {
    final entity = WishListEntities(
      id: event.productId,
      name: event.name,
      brand: event.brand,
      variantDetails: event.variantDetails,
    );
    final result = await wishListToggleUsecase(event.productId, entity);
    result.fold(
      (failure) => emit(FailureWishListState(failure.toString())),
      (_) {
        emit(InitializeWishListState([]));
        add(GetAllWishListEvent());
      },
    );
  }

  Future<void> onGetAllWishEvent(
      GetAllWishListEvent event, Emitter<WishListState> emit) async {
    emit(LoadingWishListState());
    
    await emit.forEach(
      getAllWishListUsecase(),
      onData: (either) {
        return either.fold(
          (failure) => FailureWishListState(failure.toString()),
          (items) {
            if (items.isNotEmpty) {
              return LoadedWishListState(items);
            }
            return LoadedWishListState(items);
          },
        );
      },
      onError: (error, stackTrace) {
        return FailureWishListState('Error Loading WishList');
      },
    );
  }

  Future<void> onAddtoWishList(
      AddtoWishListEvent event, Emitter<WishListState> emit) async {
    emit(LoadingWishListState());
    final result = await addToWishListUsecase(event.productId, event.item);
    result.fold(
      (failure) => emit(FailureWishListState(failure.toString())),
      (_) {
        emit(InitializeWishListState([]));
        add(GetAllWishListEvent());
      },
    );
  }

  Future<void> onDeleteWishList(
      DeleteWishListEvent event, Emitter<WishListState> emit) async {
    final result = await deleteFrmWishListUsecase(event.productId);
    result.fold(
      (failure) => emit(FailureWishListState(failure.toString())),
      (_) {
        emit(InitializeWishListState([]));
        add(GetAllWishListEvent());
      },
    );
  }
}