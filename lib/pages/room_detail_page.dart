import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/room_detail_controller.dart';

class RoomDetailPage extends GetView<RoomDetailController> {
  const RoomDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomId = Get.arguments as int;
    controller.loadRoomDetail(roomId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Ruangan'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final room = controller.room.value;
        if (room == null) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (room.image != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    room.image!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.meeting_room, size: 50),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        room.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(height: 32),
                      _buildInfoRow('Kategori ID', '${room.categoryId}'),
                      _buildInfoRow('Kapasitas', '${room.capacity} orang'),
                      _buildInfoRow('Harga', 'Rp ${room.price}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
