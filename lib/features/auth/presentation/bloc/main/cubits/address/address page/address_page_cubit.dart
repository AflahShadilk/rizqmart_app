import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_bloc.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_event.dart';
import 'package:rizqmart/features/auth/presentation/bloc/main/address/address_state.dart';
import 'address_page_state.dart';

class AddressPageCubit extends Cubit<AddressPageState> {
  final AddressBloc addressBloc;
  final String userId;
  late final StreamSubscription _subscription;

  AddressPageCubit({
    required this.addressBloc,
    required this.userId,
  }) : super(AddressPageInitial()) {
    _subscription = addressBloc.stream.listen(_onAddressBlocState);
    loadAddresses();
  }

  void _onAddressBlocState(AddressState state) {
    if (state is AddressLoadingState) {
      emit(AddressPageLoading());
    } else if (state is AddressesLoadedState) {
      if (state.addresses.isEmpty) {
        emit(AddressPageEmpty());
      } else {
        emit(AddressPageLoaded(state.addresses));
      }
    } else if (state is AddressDeletedState) {
      emit(AddressPageDeleted(state.message));
      loadAddresses();
    } else if (state is DefaultAddressSetState) {
      emit(AddressDefaultSet(state.message));
      loadAddresses();
    } else if (state is AddressErrorState) {
      emit(AddressPageError(state.message));
    }
  }

  void loadAddresses() {
    addressBloc.add(LoadAddressesEvent(userId: userId));
  }

  void deleteAddress(String addressId) {
    addressBloc.add(DeleteAddressEvent(userId: userId, addressId: addressId));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}