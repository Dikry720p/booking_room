import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/register_model.dart';
import '../models/login_model.dart';

class AuthService {
  static const String baseUrl = 'https://simaru.amisbudi.cloud/api';

  Future<bool> register(RegisterModel model) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Gagal melakukan registrasi: $e');
    }
  }

  Future<Map<String, dynamic>> login(LoginModel model) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Gagal login: ${response.body}');
    } catch (e) {
      throw Exception('Gagal login: $e');
    }
  }
}
