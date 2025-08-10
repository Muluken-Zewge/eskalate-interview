import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'package:interview_project/feature/countries/data/datasource/local/country_local_datasource.dart';
import 'package:interview_project/feature/countries/data/datasource/remote/country_remote_datasource.dart';
import 'package:interview_project/feature/countries/data/repository/country_repository_impl.dart';

import 'package:interview_project/feature/countries/domain/usecases/country_use_cases.dart';

import 'package:interview_project/feature/countries/presentation/bloc/country/country_bloc.dart';
import 'package:interview_project/feature/countries/presentation/bloc/favotite/favorite_bloc.dart';
import 'package:interview_project/feature/countries/presentation/screens/country_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Data sources
    final dio = Dio();
    final CountryRemoteDatasource remoteDataSource = CounrtyRemoteDataSourceImpl(dio);
    final CountryLocalDatasource localDatasource = CountryLocalDatasourceImpl();

    // Repository
    final countryRepository = CountryRepositoryImpl(countryRemoteDatasource: remoteDataSource, countryLocalDatasource: localDatasource);

    // Country use cases
    final getCountriesUsecase = GetCountriesUsecase(countryRepository: countryRepository);
    final searchCountriesUseCase = SearchCountriesUseCase(countryRepository: countryRepository);

    // Favorite use cases
    final toggleFavoriteUseCase = ToggleFavoriteCountryUseCase(repository: countryRepository);
    final getFavoritesUseCase = GetFavoriteCountriesUseCase(repository: countryRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CountryBloc(getCountriesUsecase: getCountriesUsecase, searchCountriesUseCase: searchCountriesUseCase),
        ),
        BlocProvider(
          create: (context) => FavoriteBloc(toggleFavoriteUseCase: toggleFavoriteUseCase, getFavoritesUseCase: getFavoritesUseCase),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Countries App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const CountryListScreen(),
      ),
    );
  }
}
