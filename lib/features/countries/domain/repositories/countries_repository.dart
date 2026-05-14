import '../entities/country.dart';

abstract class CountriesRepository {
  Future<List<Country>> fetchAll();
  Future<Country?> fetchByCca3(String cca3);
}
