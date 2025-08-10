part of 'favorite_bloc.dart';

class FavoriteState extends Equatable {
  final List<CountryEntity> favorites;
  const FavoriteState({required this.favorites});

  @override
  List<Object?> get props => [favorites];
}
