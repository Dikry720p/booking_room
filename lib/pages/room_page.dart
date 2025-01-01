import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/room_controller.dart';
import '../models/room_model.dart';

class RoomPage extends GetView<RoomController> {
  const RoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Ruangan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddEditRoomDialog(context),
          ),
        ],
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
                const Text('Tidak ada ruangan'),
                ElevatedButton(
                  onPressed: () => controller.loadRooms(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadRooms(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.rooms.length,
            itemBuilder: (context, index) {
              final room = controller.rooms[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(room.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kapasitas: ${room.capacity} orang'),
                      Text('Harga: Rp ${room.price}'),
                      if (room.description != null)
                        Text(
                          room.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                          onTap: () {
                            Get.back();
                            _showAddEditRoomDialog(context, room);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Hapus',
                              style: TextStyle(color: Colors.red)),
                          onTap: () {
                            Get.back();
                            _showDeleteConfirmation(context, room.id);
                          },
                        ),
                      ),
                    ],
                  ),
                  onTap: () => Get.toNamed('/room-detail', arguments: room.id),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  void _showAddEditRoomDialog(BuildContext context, [RoomModel? room]) {
    final nameController = TextEditingController(text: room?.name);
    final categoryIdController =
        TextEditingController(text: room?.categoryId.toString());
    final descriptionController =
        TextEditingController(text: room?.description);
    final capacityController =
        TextEditingController(text: room?.capacity.toString());
    final priceController = TextEditingController(text: room?.price.toString());

    Get.dialog(
      AlertDialog(
        title: Text(room == null ? 'Tambah Ruangan' : 'Edit Ruangan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama Ruangan',
                hintText: 'Masukkan nama ruangan',
              ),
            ),
            TextField(
              controller: categoryIdController,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                hintText: '1: Kelas, 2: Lab, 3: Aula, 4: Auditorium',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Masukkan deskripsi ruangan',
              ),
            ),
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(
                labelText: 'Kapasitas',
                hintText: 'Masukkan kapasitas ruangan',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Harga',
                hintText: 'Masukkan harga sewa',
              ),
              keyboardType: TextInputType.number,
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
              final newRoom = RoomModel(
                id: room?.id ?? 0,
                name: nameController.text,
                categoryId: int.tryParse(categoryIdController.text) ?? 1,
                description: descriptionController.text,
                capacity: int.tryParse(capacityController.text) ?? 0,
                price: int.tryParse(priceController.text) ?? 0,
                status: room?.status ?? 'available',
                createdAt: room?.createdAt ?? '',
                updatedAt: room?.updatedAt ?? '',
              );

              if (room == null) {
                controller.createRoom(newRoom);
              } else {
                controller.updateRoom(room.id, newRoom);
              }
            },
            child: Text(room == null ? 'Tambah' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int roomId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Ruangan'),
        content: const Text('Anda yakin ingin menghapus ruangan ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteRoom(roomId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
