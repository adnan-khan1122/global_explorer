import '../../../../core/errors/failuers.dart';
import '../../../../core/types/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

class GetAllCountries implements UseCase<List<Country>, NoParams> {
  GetAllCountries(this._repository);

  final CountriesRepository _repository;

  @override
  Future<Result<List<Country>>> call(NoParams params) async {
    try {
      final countries = await _repository.fetchAll();
      countries.sort((a, b) => a.nameCommon.compareTo(b.nameCommon));
      return Success(countries);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }
}
