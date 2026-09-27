import 'package:flutter/material.dart';

import 'home.dart';
import 'detail.dart';
import 'favorites_manager.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Countries')),
      body: ValueListenableBuilder<List<Country>>(
        valueListenable: FavoritesManager.favoritesNotifier,
        builder: (context, favorites, _) {
          if (favorites.isEmpty) {
            return const Center(
              child: Text('No favorite countries yet.\nTap the heart icon on a country to add it here.',
                  textAlign: TextAlign.center),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, i) {
              final country = favorites[i];
              return Card(
                child: ListTile(
                  leading: country.flagsPng != null
                      ? Image.network(country.flagsPng!, width: 50)
                      : const SizedBox(width: 50),
                  title: Text(country.name),
                  subtitle: Text(country.region),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => FavoritesManager.removeFavorite(country),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(country: country),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}