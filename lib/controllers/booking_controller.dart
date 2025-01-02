import 'package:get/get.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';
import '../services/token_service.dart';

class BookingController extends GetxController {
  static BookingController get to => Get.find();

  final RoomService _roomService = RoomService();
  final rooms = <RoomModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRooms();
  }

  Future<void> loadRooms() async {
    try {
      isLoading.value = true;
      final token = await TokenService.getToken();

      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final result = await _roomService.getAllRooms(token);
      rooms.value = result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat daftar ruangan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void bookRoom(int roomId) {
    Get.toNamed('/room-detail', arguments: roomId);
  }
}
