import 'package:get/get.dart';
import '../controllers/room_detail_controller.dart';

class RoomDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RoomDetailController());
  }
}
