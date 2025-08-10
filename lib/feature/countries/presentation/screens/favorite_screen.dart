import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_project/feature/countries/presentation/bloc/favotite/favorite_bloc.dart';
import 'package:interview_project/feature/countries/domain/entity/country_entity.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<FavoriteBloc>().add(LoadFavoritesEvent());

    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FB),
      appBar: AppBar(title: const Text("Favorite Countries"), backgroundColor: Colors.blue),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state.favorites.isEmpty) {
            return const Center(
              child: Text("No favorite countries yet", style: TextStyle(color: Colors.grey)),
            );
          }
          return _buildFavoritesGrid(state.favorites);
        },
      ),
    );
  }

  Widget _buildFavoritesGrid(List<CountryEntity> countries) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: countries.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemBuilder: (context, index) {
        final country = countries[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6, spreadRadius: 1)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  country.flag,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.flag, size: 40, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                country.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                "Population: ${country.population.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
