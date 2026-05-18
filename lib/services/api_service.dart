import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show_model.dart';

class ApiService {
  static const String _baseUrl = 'https://api.tvmaze.com';

  /// Fetch semua shows dari halaman awal
  static Future<List<ShowModel>> fetchShows() async {
    final response = await http.get(Uri.parse('$_baseUrl/shows'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => ShowModel.fromJson(json)).toList();
    }
    throw Exception('Gagal mengambil data shows');
  }

  /// Fetch detail show berdasarkan ID
  static Future<ShowModel> fetchShowDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/shows/$id'));
    if (response.statusCode == 200) {
      return ShowModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Gagal mengambil detail show');
  }
}