import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_project/feature/countries/domain/entity/country_entity.dart';
import 'package:interview_project/feature/countries/domain/usecases/country_use_cases.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final GetCountriesUsecase _getCountriesUsecase;
  final SearchCountriesUseCase _searchCountriesUseCase;

  CountryBloc({required GetCountriesUsecase getCountriesUsecase, required SearchCountriesUseCase searchCountriesUseCase})
    : _getCountriesUsecase = getCountriesUsecase,
      _searchCountriesUseCase = searchCountriesUseCase,
      super(CountryState(countries: [], isLoading: false)) {
    on<GetCountriesEvent>(_getCountriesEventHandler);
    on<SearchCountriesEvent>(_searchCountriesEventHandler);
  }

  FutureOr<void> _getCountriesEventHandler(GetCountriesEvent event, Emitter<CountryState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getCountriesUsecase.execute();

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.errormessage));
      },
      (countries) {
        emit(state.copyWith(isLoading: false, countries: countries));
      },
    );
  }

  FutureOr<void> _searchCountriesEventHandler(SearchCountriesEvent event, Emitter<CountryState> emit) async {
    final result = await _searchCountriesUseCase.execute(event.query);

    result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, errorMessage: failure.errormessage));
      },
      (filteredCountries) {
        emit(
          state.copyWith(
            isLoading: false,
            countries: filteredCountries, // update with search results
          ),
        );
      },
    );
  }
}
