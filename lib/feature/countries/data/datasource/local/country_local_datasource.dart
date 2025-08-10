import 'package:shared_preferences/shared_preferences.dart';

abstract class CountryLocalDatasource {
  Future<void> saveFavoriteCountries(List<String> countryNames);
  Future<List<String>> getFavoriteCountries();
}

class CountryLocalDatasourceImpl implements CountryLocalDatasource {
  static const String favoritesKey = 'favorite_countries';

  @override
  Future<void> saveFavoriteCountries(List<String> countryNames) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(favoritesKey, countryNames);
  }

  @override
  Future<List<String>> getFavoriteCountries() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(favoritesKey) ?? [];
  }
}
