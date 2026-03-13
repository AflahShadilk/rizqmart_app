import 'package:equatable/equatable.dart';
import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';
abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddressesEvent extends AddressEvent {
  final String userId;

  const LoadAddressesEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AddAddressEvent extends AddressEvent {
  final AddressEntities address;

  const AddAddressEvent({required this.address});

  @override
  List<Object?> get props => [address];
}

class UpdateAddressEvent extends AddressEvent {
  final AddressEntities address;

  const UpdateAddressEvent({required this.address});

  @override
  List<Object?> get props => [address];
}

class DeleteAddressEvent extends AddressEvent {
  final String userId;
  final String addressId;

  const DeleteAddressEvent({
    required this.userId,
    required this.addressId,
  });

  @override
  List<Object?> get props => [userId, addressId];
}

class SetDefaultAddressEvent extends AddressEvent {
  final String userId;
  final String addressId;

  const SetDefaultAddressEvent({
    required this.userId,
    required this.addressId,
  });

  @override
  List<Object?> get props => [userId, addressId];
}

class GetCurrentLocationEvent extends AddressEvent {}