import 'package:get/get.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';
import '../services/token_service.dart';

class RoomController extends GetxController {
  final RoomService _roomService = RoomService();
  final rooms = <RoomModel>[].obs;
  final isLoading = false.obs;
  final categoryId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      categoryId.value = Get.arguments as int;
      loadRooms();
    }
  }

  Future<void> loadRooms() async {
    try {
      isLoading.value = true;
      final token = await TokenService.getToken();
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      final result = await _roomService.getRooms(token, categoryId.value);
      rooms.value = result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat ruangan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRoom(RoomModel room) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      await _roomService.createRoom(token, room);
      await loadRooms();
      Get.back();
      Get.snackbar('Sukses', 'Ruangan berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateRoom(int id, RoomModel room) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      await _roomService.updateRoom(token, id, room);
      await loadRooms();
      Get.back();
      Get.snackbar('Sukses', 'Ruangan berhasil diupdate');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> deleteRoom(int id) async {
    try {
      final token = await TokenService.getToken();
      if (token == null) {
        Get.offAllNamed('/login');
        return;
      }

      await _roomService.deleteRoom(token, id);
      await loadRooms();
      Get.snackbar('Sukses', 'Ruangan berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
