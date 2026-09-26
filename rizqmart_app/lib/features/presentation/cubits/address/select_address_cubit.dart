import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rizqmart/features/domain/entities/main/address_entities.dart';
import 'package:rizqmart/features/presentation/cubits/address/address_selection_state.dart';

/// Cubit managing which address the user has selected during checkout or management.
class AddressSelectionCubit extends Cubit<AddressSelectionState> {
  AddressSelectionCubit() : super(const AddressSelectionState());

  
  void selectAddress(AddressEntities address) {
    emit(AddressSelectionState(selectedAddress: address));
  }

  
  void clearSelection() {
    emit(const AddressSelectionState());
  }

  
  AddressEntities? getSelectedAddress() {
    return state.selectedAddress;
  }

  
  bool isAddressSelected(String addressId) {
    return state.selectedAddress?.id == addressId;
  }
}