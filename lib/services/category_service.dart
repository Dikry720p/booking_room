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
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((item) => CategoryModel.fromJson(item))
            .toList();
      }

      throw Exception('Gagal mengambil data kategori: ${response.statusCode}');
    } catch (e) {
      print('Error getting categories: $e');
      throw Exception('Gagal mengambil data kategori: $e');
    }
  }
}
