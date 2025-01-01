import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  static const String baseUrl = 'https://simaru.amisbudi.cloud/api';

  Future<List<CategoryModel>> getCategories(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => CategoryModel.fromJson(json)).toList();
      }
      throw Exception('Gagal mengambil data kategori: ${response.body}');
    } catch (e) {
      throw Exception('Gagal mengambil data kategori: $e');
    }
  }
}
