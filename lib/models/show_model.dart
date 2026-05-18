class ShowModel {
  final int id;
  final String name;
  final String? imageUrl;
  final double? rating;
  final List<String> genres;
  final String? summary;

  ShowModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.rating,
    this.genres = const [],
    this.summary,
  });

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    // Untuk list endpoint: json adalah object show langsung
    // Untuk detail endpoint: sama
    return ShowModel(
      id: json['id'],
      name: json['name'] ?? '',
      imageUrl: json['image']?['medium'],
      rating: (json['rating']?['average'] as num?)?.toDouble(),
      genres: List<String>.from(json['genres'] ?? []),
      summary: json['summary'],
    );
  }
}