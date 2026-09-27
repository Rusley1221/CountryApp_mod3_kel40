import 'package:flutter/material.dart';

import 'home.dart';
import 'detail.dart';
import 'history_manager.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  Future<void> _confirmClearAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus semua riwayat?'),
        content: const Text(
          'Semua riwayat negara yang pernah dibuka akan dihapus permanen dan tidak bisa dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      HistoryManager.clearAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        actions: [
          ValueListenableBuilder<List<Country>>(
            valueListenable: HistoryManager.historyNotifier,
            builder: (context, history, _) {
              if (history.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Hapus semua riwayat',
                onPressed: () => _confirmClearAll(context),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<Country>>(
        valueListenable: HistoryManager.historyNotifier,
        builder: (context, history, _) {
          if (history.isEmpty) {
            return const Center(
              child: Text('Belum ada riwayat negara yang dibuka'),
            );
          }

          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, i) {
              final country = history[i];
              return Dismissible(
                key: ValueKey(country.name),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => HistoryManager.removeFromHistory(country),
                child: Card(
                  child: ListTile(
                    leading: country.flagsPng != null
                        ? Image.network(country.flagsPng!, width: 50)
                        : const SizedBox(width: 50),
                    title: Text(country.name),
                    subtitle: Text(country.region),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => HistoryManager.removeFromHistory(country),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}