import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_project/feature/countries/domain/entity/country_entity.dart';
import 'package:interview_project/feature/countries/presentation/bloc/favotite/favorite_bloc.dart';

class CountryDetailScreen extends StatelessWidget {
  final CountryEntity country;

  const CountryDetailScreen({super.key, required this.country});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF3FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF3FB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Country Details",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) {
              final isFavorite = state.favorites.any((fav) => fav.name == country.name);
              return IconButton(
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.black87),
                onPressed: () {
                  context.read<FavoriteBloc>().add(ToggleFavoriteEvent(country));
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // Flag
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                country.flag,
                height: 140,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.flag, size: 60, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),

            // Country name
            Text(country.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // Info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: .15), blurRadius: 6, spreadRadius: 1)],
              ),
              child: Column(
                children: [
                  _buildInfoRow("Region", country.region),
                  _buildInfoRow("Subregion", country.subRegion),
                  _buildInfoRow("Population", country.population.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')),
                  _buildInfoRow("Area", "${country.area.toStringAsFixed(0)} sqkm"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Timezones
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Timezone", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: country.timeZones
                  .map(
                    (tz) => Chip(
                      label: Text(tz, style: const TextStyle(fontWeight: FontWeight.w500)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:", style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          Text(value.isNotEmpty ? value : "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
