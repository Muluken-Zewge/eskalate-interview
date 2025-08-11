class CountryEntity {
  final String name;
  final String flag;
  final String region;
  final String subRegion;
  final int population;
  final double area;
  final List<String> timeZones;

  CountryEntity({
    required this.name,
    required this.flag,
    required this.region,
    required this.subRegion,
    required this.population,
    required this.area,
    required this.timeZones,
  });
}
