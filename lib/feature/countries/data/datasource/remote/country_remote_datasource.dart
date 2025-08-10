import 'package:dio/dio.dart';
import 'package:interview_project/core/constants/constants.dart';
import 'package:interview_project/feature/countries/data/model/country_model.dart';

abstract class CountryRemoteDatasource {
  Future<List<CountryModel>> getCountries();
}

class CounrtyRemoteDataSourceImpl implements CountryRemoteDatasource {
  final Dio dio;

  CounrtyRemoteDataSourceImpl(this.dio);

  @override
  Future<List<CountryModel>> getCountries() async {
    final response = await dio.get(Constants.baseUrl);

    final countryList = response.data as List;

    return countryList.map((country) => CountryModel.fromJson(country)).toList();
  }
}
