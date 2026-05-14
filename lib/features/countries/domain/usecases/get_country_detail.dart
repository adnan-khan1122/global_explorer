import '../../../../core/errors/failuers.dart';
import '../../../../core/types/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

class GetCountryDetail implements UseCase<Country, String> {
  GetCountryDetail(this._repository);

  final CountriesRepository _repository;

  @override
  Future<Result<Country>> call(String cca3) async {
    try {
      final country = await _repository.fetchByCca3(cca3);
      if (country == null) {
        return const Failure(NotFoundFailure('Country not found.'));
      }
      return Success(country);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }
}
