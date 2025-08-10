import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_project/feature/countries/domain/usecases/country_use_cases.dart';
import '../../../domain/entity/country_entity.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final ToggleFavoriteCountryUseCase toggleFavoriteUseCase;
  final GetFavoriteCountriesUseCase getFavoritesUseCase;

  FavoriteBloc({required this.toggleFavoriteUseCase, required this.getFavoritesUseCase}) : super(FavoriteState(favorites: [])) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(LoadFavoritesEvent event, Emitter<FavoriteState> emit) async {
    final favorites = await getFavoritesUseCase.execute();
    emit(FavoriteState(favorites: favorites));
  }

  Future<void> _onToggleFavorite(ToggleFavoriteEvent event, Emitter<FavoriteState> emit) async {
    await toggleFavoriteUseCase.execute(event.country);
    final favorites = await getFavoritesUseCase.execute();
    emit(FavoriteState(favorites: favorites));
  }
}
