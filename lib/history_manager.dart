import 'package:flutter/foundation.dart';

import 'home.dart';

class HistoryManager {
  HistoryManager._();

  static final ValueNotifier<List<Country>> historyNotifier =
  ValueNotifier<List<Country>>([]);

  static void addToHistory(Country country) {
    final updated = List<Country>.from(historyNotifier.value)
      ..removeWhere((c) => c.name == country.name);
    updated.insert(0, country);
    historyNotifier.value = updated;
  }

  static void removeFromHistory(Country country) {
    final updated = List<Country>.from(historyNotifier.value)
      ..removeWhere((c) => c.name == country.name);
    historyNotifier.value = updated;
  }

  static void clearAll() {
    historyNotifier.value = [];
  }
}