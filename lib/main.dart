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
import 'package:interview_project/feature/countries/presentation/screens/favorite_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dio setup with logging
    final dio = Dio()
      ..interceptors.add(
        LogInterceptor(
          request: true,
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );

    // Data sources
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
          create: (_) => CountryBloc(getCountriesUsecase: getCountriesUsecase, searchCountriesUseCase: searchCountriesUseCase),
        ),
        BlocProvider(
          create: (_) => FavoriteBloc(toggleFavoriteUseCase: toggleFavoriteUseCase, getFavoritesUseCase: getFavoritesUseCase),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Countries App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [CountryListScreen(), FavoriteScreen()];

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorites"),
        ],
      ),
    );
  }
}
