import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_explorer/core/usecase/usecase.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/country.dart';
import '../../domain/usecases/get_all_countries.dart';

part 'countries_event.dart';
part 'countries_state.dart';

EventTransformer<E> _debounce<E>(Duration duration) =>
    (events, mapper) => events.debounce(duration).switchMap(mapper);

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc({required GetAllCountries getAllCountries})
    : _getAllCountries = getAllCountries,
      super(const CountriesState()) {
    on<CountriesRequested>(_onLoad);
    on<CountriesSearchChanged>(
      _onSearchChanged,
      transformer: _debounce(const Duration(milliseconds: 350)),
    );
  }

  final GetAllCountries _getAllCountries;

  Future<void> _onLoad(
    CountriesRequested event,
    Emitter<CountriesState> emit,
  ) async {
    emit(state.copyWith(status: CountriesStatus.loading, clearError: true));
    final result = await _getAllCountries(const NoParams());
    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            status: CountriesStatus.success,
            allCountries: data,
            clearError: true,
          ),
        );
      case Failure(:final failure):
        emit(
          state.copyWith(
            status: CountriesStatus.failure,
            errorMessage: failure.message,
          ),
        );
    }
  }

  void _onSearchChanged(
    CountriesSearchChanged event,
    Emitter<CountriesState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
