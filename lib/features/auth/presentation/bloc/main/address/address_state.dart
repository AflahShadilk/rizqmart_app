import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object?> get props => [];
}

class AddressInitialState extends AddressState {}

class AddressLoadingState extends AddressState {}
class LocationLoadingState extends AddressState{}
class AddressesLoadedState extends AddressState {
  final List<AddressEntities> addresses;

  const AddressesLoadedState({required this.addresses});

  @override
  List<Object?> get props => [addresses];
}

class AddressAddedState extends AddressState {
  final AddressEntities address;

  const AddressAddedState({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddressUpdatedState extends AddressState {
  final AddressEntities address;

  const AddressUpdatedState({required this.address});

  @override
  List<Object?> get props => [address];
}

class AddressDeletedState extends AddressState {
  final String message;

  const AddressDeletedState({required this.message});

  @override
  List<Object?> get props => [message];
}

class DefaultAddressSetState extends AddressState {
  final String message;

  const DefaultAddressSetState({required this.message});

  @override
  List<Object?> get props => [message];
}

class LocationLoadedState extends AddressState {
  final double latitude;
  final double longitude;
  final double accuracy;
  final String? addressName;

  const LocationLoadedState({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.addressName,
  });

  @override
  List<Object?> get props => [latitude, longitude, accuracy, addressName];
}

class AddressErrorState extends AddressState {
  final String message;

  const AddressErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}