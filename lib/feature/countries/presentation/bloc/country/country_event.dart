part of 'country_bloc.dart';

sealed class CountryEvent {}

class GetCountriesEvent extends CountryEvent {}

class SearchCountriesEvent extends CountryEvent {
  final String query;

  SearchCountriesEvent({required this.query});
}
