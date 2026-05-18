import 'package:hive/hive.dart';

part 'favorite_show.g.dart';

@HiveType(typeId: 0)
class FavoriteShow extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? imageUrl;

  @HiveField(3)
  double? rating;

  FavoriteShow({
    required this.id,
    required this.name,
    this.imageUrl,
    this.rating,
  });
}