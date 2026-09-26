/// State holding the boolean flag for whether an address card is expanded.
class AddressCardExpandState {
  final bool isExpanded;
  const AddressCardExpandState({this.isExpanded = false});

  AddressCardExpandState copyWith({bool? isExpanded}) {
    return AddressCardExpandState(isExpanded: isExpanded ?? this.isExpanded);
  }
}