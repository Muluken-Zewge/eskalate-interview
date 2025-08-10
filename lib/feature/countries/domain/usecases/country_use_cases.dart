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

class ToggleFavoriteCountryUseCase {
  final CountryRepository _repository;
  ToggleFavoriteCountryUseCase({required CountryRepository repository}) : _repository = repository;

  Future<void> execute(CountryEntity country) {
    return _repository.toggleFavorite(country);
  }
}

class GetFavoriteCountriesUseCase {
  final CountryRepository _repository;
  GetFavoriteCountriesUseCase({required CountryRepository repository}) : _repository = repository;

  Future<List<CountryEntity>> execute() {
    return _repository.getFavoriteCountries();
  }
}

class IsFavoriteCountryUseCase {
  final CountryRepository _repository;
  IsFavoriteCountryUseCase({required CountryRepository repository}) : _repository = repository;

  Future<bool> execute(String countryName) {
    return _repository.isFavorite(countryName);
  }
}
