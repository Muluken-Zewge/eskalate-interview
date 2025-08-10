part of 'country_bloc.dart';

class CountryState extends Equatable {
  final List<CountryEntity> countries;
  final bool isLoading;
  final String? errorMessage;
  const CountryState({required this.countries, required this.isLoading, this.errorMessage});
  @override
  List<Object?> get props => [countries, isLoading, errorMessage];

  CountryState copyWith({List<CountryEntity>? countries, bool? isLoading, String? errorMessage}) {
    return CountryState(countries: countries ?? this.countries, isLoading: isLoading ?? this.isLoading, errorMessage: errorMessage);
  }
}
