import 'package:dartz/dartz.dart';
import 'package:interview_project/core/failure/failure.dart';
import 'package:interview_project/feature/countries/data/datasource/remote/country_remote_datasource.dart';
import 'package:interview_project/feature/countries/data/model/country_model.dart';
import 'package:interview_project/feature/countries/domain/entity/country_entity.dart';
import 'package:interview_project/feature/countries/domain/repositories/country_repository.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountryRemoteDatasource _countryRemoteDatasource;

  List<CountryEntity> _cachedCountries = [];

  CountryRepositoryImpl({required CountryRemoteDatasource countryRemoteDatasource}) : _countryRemoteDatasource = countryRemoteDatasource;

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountries() async {
    try {
      final models = await _countryRemoteDatasource.getCountries();

      final _cachedCountries = models.map((model) => model.mapToEntity()).toList();

      return Right(_cachedCountries);
    } catch (e) {
      return Left(Failure(errormessage: "failed to fetch countries"));
    }
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> serachCountries(String query) async {
    try {
      if (_cachedCountries.isEmpty) {
        final models = await _countryRemoteDatasource.getCountries();
        _cachedCountries = models.map((model) => model.mapToEntity()).toList();
      }

      final filtered = _cachedCountries.where((country) => country.name.toLowerCase().contains(query.toLowerCase())).toList();

      return Right(filtered);
    } catch (e) {
      return left(Failure(errormessage: 'failed to serach for countries'));
    }
  }
}
