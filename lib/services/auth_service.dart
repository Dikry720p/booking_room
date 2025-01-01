import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/register_model.dart';
import '../models/login_model.dart';

class AuthService {
  static const String baseUrl = 'https://simaru.amisbudi.cloud/api';

  Future<String> login(LoginModel model) async {
    try {
      print('Login Request: ${model.toJson()}');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      print('Login Status Code: ${response.statusCode}');
      print('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Decoded Login Data: $data');

        // Cek struktur response
        if (data['accessToken'] != null) {
          return data['accessToken'];
        } else if (data['data'] != null &&
            data['data']['accessToken'] != null) {
          return data['data']['accessToken'];
        } else if (data['token'] != null) {
          return data['token'];
        }

        throw Exception('Format response tidak sesuai: ${response.body}');
      }

      // Handle error response
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Gagal login');
    } catch (e) {
      print('Login Error: $e');
      throw Exception('Gagal login: $e');
    }
  }

  Future<bool> register(RegisterModel model) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(model.toJson()),
      );

      print('Register Status Code: ${response.statusCode}');
      print('Register Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      }

      final Map<String, dynamic> errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Gagal registrasi');
    } catch (e) {
      print('Register Error: $e');
      throw Exception('Gagal registrasi: $e');
    }
  }
}
