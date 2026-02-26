import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';

/// State for managing the currently selected address for delivery or checkout.
class AddressSelectionState {
  final AddressEntities? selectedAddress;

  const AddressSelectionState({this.selectedAddress});

  AddressSelectionState copyWith({
    AddressEntities? selectedAddress,
  }) {
    return AddressSelectionState(
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressSelectionState &&
          runtimeType == other.runtimeType &&
          selectedAddress?.id == other.selectedAddress?.id;

  @override
  int get hashCode => selectedAddress?.id.hashCode ?? 0;
}