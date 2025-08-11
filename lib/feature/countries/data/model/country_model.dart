import 'dart:convert';

import 'package:interview_project/feature/countries/domain/entity/country_entity.dart';

class CountryModel {
  final String name;
  final String flag;
  final String region;
  final String subRegion;
  final int population;
  final double area;
  final List<String> timeZones;

  CountryModel({
    required this.name,
    required this.flag,
    required this.region,
    required this.subRegion,
    required this.population,
    required this.area,
    required this.timeZones,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name']['common'] as String,
      flag: json['flags']['png'] as String,
      region: json['region'] as String? ?? '',
      subRegion: json['subregion'] as String? ?? '',
      population: (json['population'] as num).toInt(),
      area: (json['area'] as num).toDouble(),
      timeZones: (json['timezones'] as List<dynamic>).map((tz) => tz.toString()).toList(),
    );
  }

  // convert model to dart Map<Sting, dynamic> for json serialization
  Map<String, dynamic> toMap() {
    return {'name': name, 'flag': flag, 'region': region, 'subRegion': subRegion, 'population': population, 'area': area, 'timeZones': timeZones};
  }

  // convert to json string for local storage
  String toJson() => json.encode(toMap());

  CountryEntity mapToEntity() {
    return CountryEntity(name: name, flag: flag, region: region, subRegion: subRegion, population: population, area: area, timeZones: timeZones);
  }
}
