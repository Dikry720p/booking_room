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
      final requestBody = {
        'name': room.name,
        'categoryId': room.categoryId,
        'price': room.price,
        'capacity': room.capacity,
        'description': room.description,
      };

      print('Creating new room');
      print('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/rooms'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        return RoomModel.fromJson(jsonResponse);
      }

      throw Exception(
          'Gagal membuat ruangan: ${response.statusCode} - ${response.body}');
    } catch (e) {
      print('Error creating room: $e');
      throw Exception('Gagal membuat ruangan: $e');
    }
  }

  Future<RoomModel> updateRoom(String token, int id, RoomModel room) async {
    try {
      final requestBody = {
        'name': room.name,
        'categoryId': room.categoryId.toString(),
        'price': room.price.toString(),
        'capacity': room.capacity.toString(),
        'description': room.description,
      };

      print('Updating room with ID: $id');
      print('Request body: ${jsonEncode(requestBody)}');

      final response = await http.put(
        Uri.parse('$baseUrl/rooms/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return RoomModel.fromJson(jsonResponse);
      }

      throw Exception(
          'Gagal mengupdate ruangan: ${response.statusCode} - ${response.body}');
    } catch (e) {
      print('Error updating room: $e');
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

  Future<RoomModel> getRoomDetail(String token, int roomId) async {
    try {
      print('Fetching room detail for ID: $roomId');
      final response = await http.get(
        Uri.parse('$baseUrl/rooms/$roomId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        // API mengembalikan data langsung, bukan dalam wrapper 'data'
        return RoomModel.fromJson(jsonResponse);
      }

      throw Exception('Gagal mengambil detail ruangan: ${response.statusCode}');
    } catch (e) {
      print('Error getting room detail: $e');
      throw Exception('Gagal mengambil detail ruangan: $e');
    }
  }
}
