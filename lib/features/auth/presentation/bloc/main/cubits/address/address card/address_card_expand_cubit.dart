import 'package:flutter_bloc/flutter_bloc.dart';
import 'address_card_expand_state.dart';

/// Cubit toggling the expanded/collapsed state of an individual address card.
class AddressCardExpandCubit extends Cubit<AddressCardExpandState> {
  AddressCardExpandCubit() : super(const AddressCardExpandState());

  void toggle() => emit(state.copyWith(isExpanded: !state.isExpanded));
}