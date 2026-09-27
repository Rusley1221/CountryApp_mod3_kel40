import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'detail.dart';
import 'favorites_manager.dart';

enum SortMode { name, continent }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Country>> countriesFuture;


  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  final TextEditingController _searchController = TextEditingController();
  SortMode _sortMode = SortMode.name;

  @override
  void initState() {
    super.initState();
    countriesFuture = fetchCountries();


    countriesFuture.then((data) {
      if (!mounted) return;
      setState(() {
        _allCountries = data;
        _filteredCountries = _computeFilteredAndSorted(data);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Country>> fetchCountries() async {
    final uri = Uri.parse('https://www.apicountries.com/countries');
    final request = await HttpClient().getUrl(uri);
    final response = await request.close();

    if (response.statusCode == 200) {
      final respBody = await response.transform(utf8.decoder).join();
      final List jsonData = jsonDecode(respBody);
      return jsonData.map((j) => Country.fromJson(j)).toList();
    } else {
      throw Exception('Failed to load countries: ${response.statusCode}');
    }
  }

  List<Country> _computeFilteredAndSorted(List<Country> source) {
    final query = _searchController.text.toLowerCase();
    List<Country> result =
    source.where((c) => c.name.toLowerCase().contains(query)).toList();

    if (_sortMode == SortMode.name) {
      result.sort((a, b) => a.name.compareTo(b.name));
    } else {
      // Sort by continent (the API's "region" field), then by name within
      // each continent so the grouped headers below come out alphabetical.
      result.sort((a, b) {
        final regionCompare = a.region.compareTo(b.region);
        if (regionCompare != 0) return regionCompare;
        return a.name.compareTo(b.name);
      });
    }
    return result;
  }

  void _applyFilterAndSort() {
    setState(() {
      _filteredCountries = _computeFilteredAndSorted(_allCountries);
    });
  }

  void _onSearchChanged(String _) => _applyFilterAndSort();

  void _onSortChanged(SortMode mode) {
    _sortMode = mode;
    _applyFilterAndSort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          PopupMenuButton<SortMode>(
            icon: const Icon(Icons.sort),
            tooltip: 'Urutkan',
            onSelected: _onSortChanged,
            itemBuilder: (context) => const [
              PopupMenuItem(value: SortMode.name, child: Text('Nama (A-Z)')),
              PopupMenuItem(
                  value: SortMode.continent, child: Text('Benua (A-Z)')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search country...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          if (_sortMode == SortMode.continent)
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Diurutkan berdasarkan benua',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Country>>(
              future: countriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No countries found'));
                }

                // Read-only: never mutate state here. If the initState
                // .then() callback hasn't run yet for some reason, fall
                // back to computing the display list locally (without
                // setState) straight from snapshot.data.
                final displayList = _allCountries.isEmpty
                    ? _computeFilteredAndSorted(snapshot.data!)
                    : _filteredCountries;

                if (displayList.isEmpty) {
                  return const Center(child: Text('No matching countries'));
                }

                return ListView.builder(
                  itemCount: displayList.length,
                  itemBuilder: (context, i) {
                    final country = displayList[i];
                    final showHeader = _sortMode == SortMode.continent &&
                        (i == 0 || displayList[i - 1].region != country.region);

                    final card = Card(
                      child: ListTile(
                        leading: country.flagsPng != null
                            ? Image.network(country.flagsPng!, width: 50)
                            : const SizedBox(width: 50),
                        title: Text(country.name),
                        subtitle: Text(country.region),
                        trailing: ValueListenableBuilder<List<Country>>(
                          valueListenable: FavoritesManager.favoritesNotifier,
                          builder: (context, favorites, _) {
                            final isFav = FavoritesManager.isFavorite(country);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : null,
                              ),
                              onPressed: () =>
                                  FavoritesManager.toggleFavorite(country),
                            );
                          },
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

                    if (!showHeader) return card;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                          child: Text(
                            country.region,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        card,
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Country {
  final String name;
  final String region;
  final String? capital;
  final int population;
  final String? flagsPng;
  final List<dynamic>? languages;
  final List<dynamic>? currencies;

  Country({
    required this.name,
    required this.region,
    required this.population,
    this.capital,
    this.flagsPng,
    this.languages,
    this.currencies,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    List<dynamic>? langs;
    if (json['languages'] != null) {
      langs = (json['languages'] as List)
          .map((l) => l['name'].toString())
          .toList();
    }

    List<dynamic>? cur;
    if (json['currencies'] != null) {
      cur = (json['currencies'] as List)
          .map((c) => c['name'].toString())
          .toList();
    }

    return Country(
      name: json['name'] ?? 'N/A',
      region: json['region'] ?? 'N/A',
      population: json['population'] ?? 0,
      capital: json['capital'],
      flagsPng: json['flags'] != null ? json['flags']['png'] : null,
      languages: langs,
      currencies: cur,
    );
  }
}