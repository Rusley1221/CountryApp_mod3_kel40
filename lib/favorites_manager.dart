import 'package:flutter/foundation.dart';

import 'home.dart';

class FavoritesManager {
  FavoritesManager._();

  static final ValueNotifier<List<Country>> favoritesNotifier =
  ValueNotifier<List<Country>>([]);

  static bool isFavorite(Country country) {
    return favoritesNotifier.value.any((c) => c.name == country.name);
  }

  static void toggleFavorite(Country country) {
    final updated = List<Country>.from(favoritesNotifier.value);
    if (isFavorite(country)) {
      updated.removeWhere((c) => c.name == country.name);
    } else {
      updated.add(country);
    }
    favoritesNotifier.value = updated;
  }

  static void removeFavorite(Country country) {
    final updated = List<Country>.from(favoritesNotifier.value)
      ..removeWhere((c) => c.name == country.name);
    favoritesNotifier.value = updated;
  }
}