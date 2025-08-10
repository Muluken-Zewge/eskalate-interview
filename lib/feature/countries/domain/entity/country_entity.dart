class CountryEntity {
  final String name;
  final String flag;
  final String capital;
  final String region;
  final String subRegion;
  final int population;
  final double area;
  final String language;
  final List<String> timeZones;

  CountryEntity({
    required this.name,
    required this.flag,
    required this.capital,
    required this.region,
    required this.subRegion,
    required this.population,
    required this.area,
    required this.language,
    required this.timeZones,
  });
}
