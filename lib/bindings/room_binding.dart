import 'package:get/get.dart';
import '../controllers/room_controller.dart';
import '../controllers/room_detail_controller.dart';

class RoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RoomController());
    Get.lazyPut(() => RoomDetailController(), fenix: true);
  }
}
