import 'package:dartz/dartz.dart';
import 'package:interview_project/core/failure/failure.dart';
import 'package:interview_project/feature/countries/domain/entity/country_entity.dart';

abstract class CountryRepository {
  Future<Either<Failure, List<CountryEntity>>> getCountries();
  Future<Either<Failure, List<CountryEntity>>> serachCountries(String query);
}
