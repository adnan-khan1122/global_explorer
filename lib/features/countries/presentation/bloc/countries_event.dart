part of 'countries_bloc.dart';

sealed class CountriesEvent extends Equatable {
  const CountriesEvent();
  @override
  List<Object?> get props => [];
}

class CountriesRequested extends CountriesEvent {
  const CountriesRequested();
}

class CountriesSearchChanged extends CountriesEvent {
  const CountriesSearchChanged(this.query);
  final String query;
  @override
  List<Object?> get props => [query];
}
