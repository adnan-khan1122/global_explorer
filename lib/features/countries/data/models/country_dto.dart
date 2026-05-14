import 'package:equatable/equatable.dart';

class CountryDto extends Equatable {
  const CountryDto({
    required this.cca3,
    required this.cca2,
    required this.nameCommon,
    required this.nameOfficial,
    required this.region,
    this.subregion,
    required this.flagPng,
    required this.capital,
    this.population,
    this.area,
    this.mapsOpenStreetMaps,
  });

  final String cca3;
  final String cca2;
  final String nameCommon;
  final String nameOfficial;
  final String region;
  final String? subregion;
  final String? flagPng;
  final List<String> capital;
  final int? population;
  final double? area;
  final String? mapsOpenStreetMaps;

  factory CountryDto.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as Map<String, dynamic>? ?? {};
    final flags = json['flags'] as Map<String, dynamic>? ?? {};
    final capitals = json['capital'];
    final maps = json['maps'] as Map<String, dynamic>?;
    return CountryDto(
      cca3: json['cca3'] as String? ?? '',
      cca2: (json['cca2'] as String?)?.toUpperCase() ?? '',
      nameCommon: name['common'] as String? ?? '',
      nameOfficial: name['official'] as String? ?? '',
      region: json['region'] as String? ?? '',
      subregion: json['subregion'] as String?,
      flagPng: flags['png'] as String?,
      capital: capitals is List
          ? capitals.map((e) => e.toString()).toList(growable: false)
          : const [],
      population: json['population'] as int?,
      area: (json['area'] as num?)?.toDouble(),
      mapsOpenStreetMaps: maps?['openStreetMaps'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    cca3,
    cca2,
    nameCommon,
    nameOfficial,
    region,
    subregion,
    flagPng,
    capital,
    population,
    area,
    mapsOpenStreetMaps,
  ];
}
