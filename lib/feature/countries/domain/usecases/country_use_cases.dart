import 'package:dartz/dartz.dart';
import 'package:interview_project/core/failure/failure.dart';
import 'package:interview_project/feature/countries/domain/entity/country_entity.dart';
import 'package:interview_project/feature/countries/domain/repositories/country_repository.dart';

class GetCountriesUsecase {
  final CountryRepository _countryRepository;

  GetCountriesUsecase({required CountryRepository countryRepository}) : _countryRepository = countryRepository;
  Future<Either<Failure, List<CountryEntity>>> execute() {
    return _countryRepository.getCountries();
  }
}

class SearchCountriesUseCase {
  final CountryRepository _countryRepository;

  SearchCountriesUseCase({required CountryRepository countryRepository}) : _countryRepository = countryRepository;
  Future<Either<Failure, List<CountryEntity>>> execute(String query) {
    return _countryRepository.serachCountries(query);
  }
}
