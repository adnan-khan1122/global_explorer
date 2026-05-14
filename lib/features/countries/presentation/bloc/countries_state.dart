part of 'countries_bloc.dart';

enum CountriesStatus { initial, loading, success, failure }

class CountriesState extends Equatable {
  const CountriesState({
    this.status = CountriesStatus.initial,
    this.allCountries = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  final CountriesStatus status;
  final List<Country> allCountries;
  final String searchQuery;
  final String? errorMessage;

  List<Country> get filtered {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return allCountries;
    return allCountries
        .where((c) {
          return c.nameCommon.toLowerCase().contains(q) ||
              c.region.toLowerCase().contains(q) ||
              c.capital.join(' ').toLowerCase().contains(q);
        })
        .toList(growable: false);
  }

  CountriesState copyWith({
    CountriesStatus? status,
    List<Country>? allCountries,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CountriesState(
      status: status ?? this.status,
      allCountries: allCountries ?? this.allCountries,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, allCountries, searchQuery, errorMessage];
}
