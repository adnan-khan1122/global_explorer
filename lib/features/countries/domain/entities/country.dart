import 'package:equatable/equatable.dart';

class Country extends Equatable {
  const Country({
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

  String get displayCapital => capital.isEmpty ? '—' : capital.first;

  String get imageSearchQuery =>
      capital.isNotEmpty ? '$nameCommon ${capital.first}' : nameCommon;

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
