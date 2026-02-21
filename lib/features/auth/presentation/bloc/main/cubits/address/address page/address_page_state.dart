import 'package:rizqmart/features/auth/domain/entities/main/address_entities.dart';

abstract class AddressPageState {}

class AddressPageInitial extends AddressPageState {}

class AddressPageLoading extends AddressPageState {}

class AddressPageLoaded extends AddressPageState {
  final List<AddressEntities> addresses;
  AddressPageLoaded(this.addresses);
}

class AddressPageEmpty extends AddressPageState {}

class AddressPageError extends AddressPageState {
  final String message;
  AddressPageError(this.message);
}

class AddressPageDeleted extends AddressPageState {
  final String message;
  AddressPageDeleted(this.message);
}

class AddressDefaultSet extends AddressPageState {
  final String message;
  AddressDefaultSet(this.message);
} 