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

  /// For API JSON
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

  /// For reading from local storage or any plain map
  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      name: map['name'] as String,
      flag: map['flag'] as String,
      region: map['region'] as String? ?? '',
      subRegion: map['subRegion'] as String? ?? '',
      population: (map['population'] as num).toInt(),
      area: (map['area'] as num).toDouble(),
      timeZones: (map['timeZones'] as List<dynamic>).map((tz) => tz.toString()).toList(),
    );
  }

  /// Convert model to Map for storage
  Map<String, dynamic> toMap() {
    return {'name': name, 'flag': flag, 'region': region, 'subRegion': subRegion, 'population': population, 'area': area, 'timeZones': timeZones};
  }

  /// Convert model to JSON String for storage
  String toJson() => json.encode(toMap());

  /// Convert JSON string back to CountryModel
  factory CountryModel.fromJsonString(String source) => CountryModel.fromMap(json.decode(source));

  CountryEntity mapToEntity() {
    return CountryEntity(name: name, flag: flag, region: region, subRegion: subRegion, population: population, area: area, timeZones: timeZones);
  }
}
