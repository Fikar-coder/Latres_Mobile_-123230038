import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/show_model.dart';
import '../services/api_service.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ShowModel>> _showsFuture;

  @override
  void initState() {
    super.initState();
    _showsFuture = ApiService.fetchShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Skuy Nonton! 🎬',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF141414),
        elevation: 0,
      ),
      body: FutureBuilder<List<ShowModel>>(
        future: _showsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, color: Colors.grey, size: 64),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() => _showsFuture = ApiService.fetchShows()),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914)),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final shows = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: shows.length,
            itemBuilder: (context, index) {
              final show = shows[index];
              return _ShowCard(show: show);
            },
          );
        },
      ),
    );
  }
}

class _ShowCard extends StatelessWidget {
  final ShowModel show;
  const _ShowCard({required this.show});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DetailPage(showId: show.id)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F1F1F),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            Expanded(
              child: show.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: show.imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFE50914),
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.movie, color: Colors.grey, size: 40),
                    ),
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        show.rating?.toStringAsFixed(1) ?? 'N/A',
                        style: const TextStyle(color: Colors.amber, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}