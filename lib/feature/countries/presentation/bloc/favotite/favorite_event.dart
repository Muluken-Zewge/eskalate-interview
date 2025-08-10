part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoriteEvent {}

class ToggleFavoriteEvent extends FavoriteEvent {
  final CountryEntity country;
  ToggleFavoriteEvent(this.country);
  @override
  List<Object?> get props => [country];
}
