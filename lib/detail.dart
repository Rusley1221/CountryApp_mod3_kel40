import 'package:flutter/material.dart';

import 'home.dart';
import 'favorites_manager.dart';
import 'history_manager.dart';

class DetailPage extends StatefulWidget {
  final Country country;

  const DetailPage({super.key, required this.country});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();

    HistoryManager.addToHistory(widget.country);
  }

  @override
  Widget build(BuildContext context) {
    final country = widget.country;
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name),
        actions: [
          ValueListenableBuilder<List<Country>>(
            valueListenable: FavoritesManager.favoritesNotifier,
            builder: (context, favorites, _) {
              final isFav = FavoritesManager.isFavorite(country);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                onPressed: () => FavoritesManager.toggleFavorite(country),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (country.flagsPng != null)
              Center(child: Image.network(country.flagsPng!, width: 200)),
            const SizedBox(height: 16),
            Text('Name: ${country.name}', style: const TextStyle(fontSize: 18)),
            Text(
              'Capital: ${country.capital ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Region: ${country.region}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Population: ${country.population}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Languages: ${country.languages?.join(', ') ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Currencies: ${country.currencies?.join(', ') ?? 'N/A'}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}