import 'package:equatable/equatable.dart';

class FavoriteCountrySummary extends Equatable {
  const FavoriteCountrySummary({
    required this.cca3,
    required this.nameCommon,
    this.flagPng,
    this.region,
  });

  final String cca3;
  final String nameCommon;
  final String? flagPng;
  final String? region;

  @override
  List<Object?> get props => [cca3, nameCommon, flagPng, region];
}
