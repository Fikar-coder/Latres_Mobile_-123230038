import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../hive/favorite_show.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Favorit', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<FavoriteShow>('favorites').listenable(),
        builder: (context, Box<FavoriteShow> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, color: Colors.grey, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada favorit',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final favorites = box.values.toList();
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final show = favorites[index];
              return Card(
                color: const Color(0xFF1F1F1F),
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailPage(showId: show.id)),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: show.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: show.imageUrl!,
                            width: 50,
                            height: 70,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.movie, color: Colors.grey),
                          )
                        : const Icon(Icons.movie, color: Colors.grey, size: 50),
                  ),
                  title: Text(
                    show.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        show.rating?.toStringAsFixed(1) ?? 'N/A',
                        style: const TextStyle(color: Colors.amber),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => show.delete(),
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