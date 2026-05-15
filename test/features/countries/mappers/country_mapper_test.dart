import 'package:flutter_test/flutter_test.dart';
import 'package:global_explorer/features/countries/data/mappers/country_mapper.dart';
import 'package:global_explorer/features/countries/data/models/country_dto.dart';
import 'package:global_explorer/features/countries/domain/entities/country.dart';

import '../../../fixtures.dart';


void main() {
  group('CountryMapper.toEntity', () {
    test('maps all fields correctly from DTO', () {
      final entity = CountryMapper.toEntity(tCountryDto);

      expect(entity.cca3, 'DEU');
      expect(entity.cca2, 'DE');
      expect(entity.nameCommon, 'Germany');
      expect(entity.nameOfficial, 'Federal Republic of Germany');
      expect(entity.region, 'Europe');
      expect(entity.subregion, 'Western Europe');
      expect(entity.flagPng, 'https://flagcdn.com/w320/de.png');
      expect(entity.capital, ['Berlin']);
      expect(entity.population, 83240000);
      expect(entity.area, 357114.0);
      expect(entity.mapsOpenStreetMaps,
          'https://www.openstreetmap.org/relation/51477');
    });

    test('returns a Country instance', () {
      expect(CountryMapper.toEntity(tCountryDto), isA<Country>());
    });

    test('displayCapital returns first capital', () {
      final entity = CountryMapper.toEntity(tCountryDto);
      expect(entity.displayCapital, 'Berlin');
    });

    test('displayCapital returns dash when capital list is empty', () {
      final dto = CountryDto(
        cca3: 'TST',
        cca2: 'TS',
        nameCommon: 'Test',
        nameOfficial: 'Test Country',
        region: 'Region',
        capital: const [],
        flagPng: null,
      );
      expect(CountryMapper.toEntity(dto).displayCapital, '—');
    });

    test('imageSearchQuery combines country name and capital', () {
      expect(CountryMapper.toEntity(tCountryDto).imageSearchQuery,
          'Germany Berlin');
    });

    test('imageSearchQuery falls back to name only when no capital', () {
      final dto = CountryDto(
        cca3: 'TST',
        cca2: 'TS',
        nameCommon: 'Testland',
        nameOfficial: 'Testland',
        region: 'Region',
        capital: const [],
        flagPng: null,
      );
      expect(CountryMapper.toEntity(dto).imageSearchQuery, 'Testland');
    });
  });
}
