import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/booking_model.dart';

class BookingService {
  static const String baseUrl = 'https://simaru.amisbudi.cloud/api';

  Future<List<BookingModel>> getRoomBookings(String token, int roomId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/rooms/$roomId/bookings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> bookingsData = jsonResponse['data'];
      return bookingsData.map((item) => BookingModel.fromJson(item)).toList();
    }
    throw Exception('Gagal mengambil data booking');
  }

  Future<BookingModel> createBooking(
      String token, int roomId, String startTime, String endTime) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'room_id': roomId,
        'start_time': startTime,
        'end_time': endTime,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return BookingModel.fromJson(jsonResponse['data']);
    }
    throw Exception('Gagal membuat booking');
  }
}
