import 'package:booking_room/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/room_detail_controller.dart';

class RoomDetailPage extends GetView<RoomDetailController> {
  const RoomDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Building RoomDetailPage with arguments: ${Get.arguments}');

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
                      const SizedBox(height: 16),
                      _buildInfoRow('Kategori',
                          room.category?.name ?? 'Tidak ada kategori'),
                      _buildInfoRow('Kapasitas', '${room.capacity} orang'),
                      _buildInfoRow('Harga', 'Rp ${room.price}'),
                      _buildInfoRow('Status', room.status),
                      const SizedBox(height: 16),
                      const Text(
                        'Deskripsi:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        room.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Status: ${room.status}',
                style: TextStyle(
                  color: room.status == 'available' ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (room.status == 'available') ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _showBookingDialog(context),
                  child: const Text('Booking Ruangan'),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Jadwal Booking:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(() {
                if (controller.bookings.isEmpty) {
                  return const Text('Belum ada booking');
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.bookings[index];
                    return Card(
                      child: ListTile(
                        title:
                            Text('${booking.startTime} - ${booking.endTime}'),
                        subtitle: Text('Status: ${booking.status}'),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  void _showBookingDialog(BuildContext context) {
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('Booking Ruangan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: startTimeController,
              decoration: const InputDecoration(
                labelText: 'Waktu Mulai (YYYY-MM-DD HH:mm)',
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: endTimeController,
              decoration: const InputDecoration(
                labelText: 'Waktu Selesai (YYYY-MM-DD HH:mm)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.createBooking(
                startTimeController.text,
                endTimeController.text,
              );
              Get.back();
            },
            child: const Text('Booking'),
          ),
        ],
      ),
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
