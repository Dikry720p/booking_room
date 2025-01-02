import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booking_controller.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.find<BookingController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Ruangan'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.rooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Tidak ada ruangan tersedia'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.loadRooms(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Nama Ruangan')),
                DataColumn(label: Text('Kategori')),
                DataColumn(label: Text('Kapasitas')),
                DataColumn(label: Text('Harga')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Aksi')),
              ],
              rows: controller.rooms.map((room) {
                final isAvailable = room.status.toLowerCase() == 'available';
                return DataRow(
                  cells: [
                    DataCell(Text(room.name)),
                    DataCell(Text(room.category?.name ?? '-')),
                    DataCell(Text('${room.capacity} orang')),
                    DataCell(Text('Rp ${room.price}')),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isAvailable ? Colors.green[100] : Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          room.status,
                          style: TextStyle(
                            color: isAvailable
                                ? Colors.green[900]
                                : Colors.red[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      ElevatedButton(
                        onPressed: isAvailable
                            ? () =>
                                Get.toNamed('/room-detail', arguments: room.id)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isAvailable ? Colors.blue : Colors.grey,
                        ),
                        child: const Text('Booking'),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.loadRooms(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
