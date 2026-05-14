import '../../domain/entities/country.dart';
import '../../domain/repositories/countries_repository.dart';
import '../datasources/countries_rest_data_source.dart';
import '../mappers/country_mapper.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  CountriesRepositoryImpl({required CountriesRestDataSource remote})
    : _remote = remote;

  final CountriesRestDataSource _remote;

  @override
  Future<List<Country>> fetchAll() async {
    final dtos = await _remote.fetchAllCountries();
    return dtos.map(CountryMapper.toEntity).toList(growable: false);
  }

  @override
  Future<Country?> fetchByCca3(String cca3) async {
    final dto = await _remote.fetchCountryByAlpha3(cca3);
    if (dto == null) return null;
    return CountryMapper.toEntity(dto);
  }
}
