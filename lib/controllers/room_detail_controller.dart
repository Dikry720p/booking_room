import 'package:get/get.dart';
import '../models/room_model.dart';
import '../models/booking_model.dart';
import '../services/room_service.dart';
import '../services/booking_service.dart';
import '../services/token_service.dart';

class RoomDetailController extends GetxController {
  final RoomService _roomService = RoomService();
  final BookingService _bookingService = BookingService();

  final room = Rxn<RoomModel>();
  final bookings = <BookingModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final roomId = Get.arguments as int?;
    if (roomId != null) {
      loadRoom(roomId);
      loadBookings(roomId);
    }
  }

  Future<void> loadRoom(int roomId) async {
    try {
      isLoading.value = true;
      final token = await TokenService.getToken();
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }
      room.value = await _roomService.getRoomDetail(token, roomId);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail ruangan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBookings(int roomId) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }
      bookings.value = await _bookingService.getRoomBookings(token, roomId);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat jadwal booking: $e');
    }
  }

  Future<void> createBooking(String startTime, String endTime) async {
    try {
      isLoading.value = true;
      final token = await TokenService.getToken();
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      if (room.value == null) return;

      await _bookingService.createBooking(
        token,
        room.value!.id,
        startTime,
        endTime,
      );

      await loadBookings(room.value!.id);
      Get.snackbar('Sukses', 'Booking berhasil dibuat');
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat booking: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
