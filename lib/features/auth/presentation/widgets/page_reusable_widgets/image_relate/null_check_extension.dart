extension SafeListAccess<T> on List<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}
