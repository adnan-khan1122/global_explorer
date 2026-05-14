import '../../domain/entities/country.dart';
import '../models/country_dto.dart';

class CountryMapper {
  const CountryMapper._();

  static Country toEntity(CountryDto dto) => Country(
    cca3: dto.cca3,
    cca2: dto.cca2,
    nameCommon: dto.nameCommon,
    nameOfficial: dto.nameOfficial,
    region: dto.region,
    subregion: dto.subregion,
    flagPng: dto.flagPng,
    capital: dto.capital,
    population: dto.population,
    area: dto.area,
    mapsOpenStreetMaps: dto.mapsOpenStreetMaps,
  );
}
