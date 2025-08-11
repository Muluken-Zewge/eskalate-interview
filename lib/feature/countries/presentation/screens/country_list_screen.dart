import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_project/feature/countries/domain/entity/country_entity.dart';
import 'package:interview_project/feature/countries/presentation/bloc/country/country_bloc.dart';
import 'package:interview_project/feature/countries/presentation/bloc/favotite/favorite_bloc.dart';
import 'package:interview_project/feature/countries/presentation/screens/country_detail_screen.dart';
import 'favorite_screen.dart';

class CountryListScreen extends StatefulWidget {
  const CountryListScreen({super.key});

  @override
  State<CountryListScreen> createState() => _CountryListScreenState();
}

class _CountryListScreenState extends State<CountryListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CountryBloc>().add(GetCountriesEvent());
    context.read<FavoriteBloc>().add(LoadFavoritesEvent());
  }

  void _onSearchChanged(String query) {
    context.read<CountryBloc>().add(SearchCountriesEvent(query: query));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: BlocBuilder<CountryBloc, CountryState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.blue),
                          SizedBox(height: 12),
                          Text("Loading countries...", style: TextStyle(color: Colors.blueGrey)),
                        ],
                      ),
                    );
                  }

                  if (state.errorMessage != null) {
                    return Center(
                      child: Text(state.errorMessage!, style: const TextStyle(color: Colors.red)),
                    );
                  }

                  if (state.countries.isEmpty) {
                    return const Center(
                      child: Text("No countries found", style: TextStyle(color: Colors.grey)),
                    );
                  }

                  return _buildCountriesGrid(state.countries);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: "Search countries...",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white.withValues(alpha: .9),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCountriesGrid(List<CountryEntity> countries) {
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, favState) {
        final favoriteNames = favState.favorites.map((c) => c.name).toSet();

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: countries.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemBuilder: (context, index) {
            final country = countries[index];
            final isFavorite = favoriteNames.contains(country.name);

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CountryDetailScreen(country: country)));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: .15), blurRadius: 6, spreadRadius: 1)],
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
                    IconButton(
                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                      onPressed: () {
                        context.read<FavoriteBloc>().add(ToggleFavoriteEvent(country));
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
