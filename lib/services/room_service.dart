import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room_model.dart';

class RoomService {
  static const String baseUrl = 'https://simaru.amisbudi.cloud/api';

  Future<List<RoomModel>> getRooms(String token, int categoryId) async {
    try {
      print('Fetching rooms for category ID: $categoryId');
      print('Using token: $token');

      final response = await http.get(
        Uri.parse('$baseUrl/rooms?category_id=$categoryId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        // Mengambil data dari response yang dipaginasi
        if (jsonResponse['data'] != null && jsonResponse['data'] is List) {
          final List<dynamic> roomsData = jsonResponse['data'];
          print('Parsed rooms data: $roomsData');
          return roomsData.map((item) => RoomModel.fromJson(item)).toList();
        }
        throw Exception('Format response tidak sesuai');
      }

      throw Exception('Gagal mengambil data ruangan: ${response.statusCode}');
    } catch (e) {
      print('Error getting rooms: $e');
      throw Exception('Gagal mengambil data ruangan: $e');
    }
  }

  Future<RoomModel> createRoom(String token, RoomModel room) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/rooms'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(room.toJson()),
      );

      if (response.statusCode == 201) {
        return RoomModel.fromJson(jsonDecode(response.body)['data']);
      }
      throw Exception('Gagal menambah ruangan');
    } catch (e) {
      throw Exception('Gagal menambah ruangan: $e');
    }
  }

  Future<RoomModel> updateRoom(String token, int id, RoomModel room) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/rooms/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(room.toJson()),
      );

      if (response.statusCode == 200) {
        return RoomModel.fromJson(jsonDecode(response.body)['data']);
      }
      throw Exception('Gagal mengupdate ruangan');
    } catch (e) {
      throw Exception('Gagal mengupdate ruangan: $e');
    }
  }

  Future<bool> deleteRoom(String token, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/rooms/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Gagal menghapus ruangan: $e');
    }
  }

  Future<RoomModel> getDetailRoom(String token, int id) async {
    try {
      print('Calling API for room ID: $id with token: $token');
      final response = await http.get(
        Uri.parse('$baseUrl/rooms/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Detail Response Status: ${response.statusCode}');
      print('Detail Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Cek struktur response
        Map<String, dynamic> roomData;
        if (responseData['data'] != null) {
          roomData = responseData['data'];
        } else {
          roomData = responseData;
        }

        print('Parsed room data: $roomData');
        return RoomModel.fromJson(roomData);
      }

      // Handle error cases
      if (response.statusCode == 404) {
        throw Exception('Ruangan tidak ditemukan');
      }
      throw Exception('Gagal mengambil detail ruangan: ${response.statusCode}');
    } catch (e) {
      print('Error in getDetailRoom: $e');
      throw Exception('Gagal mengambil detail ruangan: $e');
    }
  }
}
