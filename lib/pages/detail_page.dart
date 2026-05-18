import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hive/hive.dart';
import '../models/show_model.dart';
import '../services/api_service.dart';
import '../hive/favorite_show.dart';

class DetailPage extends StatefulWidget {
  final int showId;
  const DetailPage({super.key, required this.showId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<ShowModel> _detailFuture;
  bool _isFavorite = false;
  late Box<FavoriteShow> _favBox;

  @override
  void initState() {
    super.initState();
    _detailFuture = ApiService.fetchShowDetail(widget.showId);
    _favBox = Hive.box<FavoriteShow>('favorites');
    _isFavorite = _favBox.containsKey(widget.showId);
  }

  void _toggleFavorite(ShowModel show) {
    setState(() {
      if (_isFavorite) {
        _favBox.delete(show.id);
        _isFavorite = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dihapus dari favorit'), duration: Duration(seconds: 1)),
        );
      } else {
        _favBox.put(
          show.id,
          FavoriteShow(
            id: show.id,
            name: show.name,
            imageUrl: show.imageUrl,
            rating: show.rating,
          ),
        );
        _isFavorite = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ditambahkan ke favorit ❤️'), duration: Duration(seconds: 1)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF141414),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<ShowModel>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFE50914)),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final show = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                if (show.imageUrl != null)
                  SizedBox(
                    width: double.infinity,
                    height: 280,
                    child: CachedNetworkImage(
                      imageUrl: show.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(color: Color(0xFFE50914)),
                      ),
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Judul
                      Text(
                        show.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            show.rating?.toStringAsFixed(1) ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Genre
                      if (show.genres.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          children: show.genres
                              .map(
                                (g) => Chip(
                                  label: Text(g, style: const TextStyle(fontSize: 11)),
                                  backgroundColor: const Color(0xFF2A2A2A),
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  padding: EdgeInsets.zero,
                                ),
                              )
                              .toList(),
                        ),
                      const SizedBox(height: 16),

                      // Tombol Aksi
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.play_arrow, color: Colors.white),
                              label: const Text(
                                'Nonton',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE50914),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Tombol Favorit
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              onPressed: () => _toggleFavorite(show),
                              icon: Icon(
                                _isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: _isFavorite ? Colors.red : Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Overview
                      if (show.summary != null) ...[
                        const Text(
                          'Overview',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Html(
                          data: show.summary!,
                          style: {
                            'body': Style(
                              color: Colors.white70,
                              fontSize: FontSize(14),
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                            ),
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}