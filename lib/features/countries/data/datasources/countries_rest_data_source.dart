import 'package:dio/dio.dart';

import '../models/country_dto.dart';

class CountriesRestDataSource {
  CountriesRestDataSource({required this.dio});

  final Dio dio;
  static const _base = 'https://restcountries.com/v3.1';

  Future<List<CountryDto>> fetchAllCountries() async {
    final response = await dio.get<List<dynamic>>(
      '$_base/all',
      queryParameters: {
        'fields':
            'cca3,cca2,name,flags,region,subregion,capital,population,area,maps',
      },
    );
    final list = response.data;
    if (list == null) return [];
    return list
        .map((e) => CountryDto.fromJson(e as Map<String, dynamic>))
        .where((c) => c.cca3.isNotEmpty)
        .toList(growable: false);
  }

  Future<CountryDto?> fetchCountryByAlpha3(String cca3) async {
    final code = cca3.trim();
    if (code.isEmpty) return null;
    try {
      final response = await dio.get<dynamic>(
        '$_base/alpha/$code',
        queryParameters: {
          'fields':
              'cca3,cca2,name,flags,region,subregion,capital,population,area,maps',
        },
      );
      final data = response.data;
      if (data is List && data.isNotEmpty) {
        return CountryDto.fromJson(data.first as Map<String, dynamic>);
      }
      if (data is Map<String, dynamic>) return CountryDto.fromJson(data);
      return null;
    } on DioException catch (_) {
      return null;
    }
  }
}
