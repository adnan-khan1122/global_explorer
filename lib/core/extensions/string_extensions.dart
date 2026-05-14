extension StringX on String {
  /// Returns the string or a fallback when blank / empty.
  String orDefault(String fallback) => trim().isEmpty ? fallback : this;

  /// Capitalises only the first letter.
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
