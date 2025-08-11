import 'package:dartz/dartz.dart';
import 'package:interview_project/core/failure/failure.dart';
import 'package:interview_project/feature/countries/data/datasource/local/country_local_datasource.dart';
import 'package:interview_project/feature/countries/data/datasource/remote/country_remote_datasource.dart';
import 'package:interview_project/feature/countries/data/model/country_model.dart';
import 'package:interview_project/feature/countries/domain/entity/country_entity.dart';
import 'package:interview_project/feature/countries/domain/repositories/country_repository.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDatasource _remoteDatasource;
  final CountryLocalDatasource _localDatasource;

  List<CountryEntity> _cachedCountries = [];

  CountryRepositoryImpl({required CountryRemoteDatasource countryRemoteDatasource, required CountryLocalDatasource countryLocalDatasource})
    : _remoteDatasource = countryRemoteDatasource,
      _localDatasource = countryLocalDatasource;

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountries() async {
    try {
      if (_cachedCountries.isEmpty) {
        final models = await _remoteDatasource.getCountries();
        _cachedCountries = models.map((e) => e.mapToEntity()).toList();
      }
      return Right(_cachedCountries);
    } catch (e) {
      print('error: ${e.toString()}');
      return Left(Failure(errormessage: "Failed to fetch countries"));
    }
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> serachCountries(String query) async {
    try {
      if (_cachedCountries.isEmpty) {
        final models = await _remoteDatasource.getCountries();
        _cachedCountries = models.map((e) => e.mapToEntity()).toList();
      }
      final filtered = _cachedCountries.where((c) => c.name.toLowerCase().contains(query.toLowerCase())).toList();
      return Right(filtered);
    } catch (e) {
      return Left(Failure(errormessage: "Failed to search countries"));
    }
  }

  @override
  Future<void> toggleFavorite(CountryEntity country) async {
    final favorites = await _localDatasource.getFavoriteCountries();
    if (favorites.contains(country.name)) {
      favorites.remove(country.name);
    } else {
      favorites.add(country.name);
    }
    await _localDatasource.saveFavoriteCountries(favorites);
  }

  @override
  Future<List<CountryEntity>> getFavoriteCountries() async {
    final favorites = await _localDatasource.getFavoriteCountries();
    return _cachedCountries.where((c) => favorites.contains(c.name)).toList();
  }

  @override
  Future<bool> isFavorite(String countryName) async {
    final favorites = await _localDatasource.getFavoriteCountries();
    return favorites.contains(countryName);
  }
}
