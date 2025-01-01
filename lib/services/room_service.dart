import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room_model.dart';

class RoomService {
  static const String baseUrl = 'https://simaru.amisbudi.cloud/api';

  Future<List<RoomModel>> getRooms(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rooms'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body)['data'];
        return data.map((json) => RoomModel.fromJson(json)).toList();
      }
      throw Exception('Gagal mengambil data ruangan');
    } catch (e) {
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
}
