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
    print('RoomDetailController onInit with arguments: ${Get.arguments}');
    if (Get.arguments != null) {
      final roomId = Get.arguments as int;
      print('Loading room detail for ID: $roomId');
      loadRoomDetail(roomId);
    }
  }

  @override
  void onClose() {
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

      print('Fetching room detail with ID: $id');
      final roomDetail = await _roomService.getDetailRoom(token, id);
      print('Received room detail: ${roomDetail.toJson()}');
      room.value = roomDetail;
    } catch (e) {
      print('Error loading room detail: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat detail ruangan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
