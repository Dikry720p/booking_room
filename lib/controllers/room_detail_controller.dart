import 'package:get/get.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';
import '../services/token_service.dart';

class RoomDetailController extends GetxController {
  final RoomService _roomService = RoomService();
  final room = Rxn<RoomModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Cek apakah ada arguments dan pastikan tipe datanya int
    if (Get.arguments != null) {
      final roomId = Get.arguments as int;
      loadRoomDetail(roomId);
    }
  }

  @override
  void onClose() {
    // Reset data saat controller ditutup
    room.value = null;
    super.onClose();
  }

  Future<void> loadRoomDetail(int id) async {
    try {
      isLoading.value = true;
      final token = await TokenService.getToken();
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final roomDetail = await _roomService.getDetailRoom(token, id);
      room.value = roomDetail;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
