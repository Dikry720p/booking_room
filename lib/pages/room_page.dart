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
        automaticallyImplyLeading: false,
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
                  onPressed: controller.loadRooms,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadRooms,
          child: ListView.builder(
            itemCount: controller.rooms.length,
            itemBuilder: (context, index) {
              final room = controller.rooms[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(room.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kapasitas: ${room.capacity} orang'),
                      Text('Harga: Rp ${room.price}'),
                      Text('Status: ${room.status}'),
                    ],
                  ),
                  onTap: () => Get.toNamed('/room-detail', arguments: room.id),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(room),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(room),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog() {
    final nameController = TextEditingController();
    final categoryIdController = TextEditingController();
    final priceController = TextEditingController();
    final capacityController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text('Tambah Ruangan'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Ruangan'),
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: categoryIdController,
                  decoration: const InputDecoration(labelText: 'ID Kategori'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: capacityController,
                  decoration: const InputDecoration(labelText: 'Kapasitas'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newRoom = RoomModel(
                  name: nameController.text,
                  categoryId: int.parse(categoryIdController.text),
                  price: int.parse(priceController.text),
                  capacity: int.parse(capacityController.text),
                  description: descriptionController.text,
                  status: 'draft',
                  createdAt: DateTime.now().toIso8601String(),
                  updatedAt: DateTime.now().toIso8601String(),
                );
                controller.createRoom(newRoom);
                Get.back();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(RoomModel room) {
    final nameController = TextEditingController(text: room.name);
    final categoryIdController =
        TextEditingController(text: room.categoryId.toString());
    final priceController = TextEditingController(text: room.price.toString());
    final capacityController =
        TextEditingController(text: room.capacity.toString());
    final descriptionController = TextEditingController(text: room.description);
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Ruangan'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Ruangan'),
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: categoryIdController,
                  decoration: const InputDecoration(labelText: 'ID Kategori'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: capacityController,
                  decoration: const InputDecoration(labelText: 'Kapasitas'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Tidak boleh kosong' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final updatedRoom = RoomModel(
                  id: room.id,
                  name: nameController.text,
                  categoryId: int.parse(categoryIdController.text),
                  price: int.parse(priceController.text),
                  capacity: int.parse(capacityController.text),
                  description: descriptionController.text,
                  status: room.status,
                  createdAt: room.createdAt,
                  updatedAt: DateTime.now().toIso8601String(),
                );
                controller.updateRoom(room.id!, updatedRoom);
                Get.back();
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(RoomModel room) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus ruangan ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteRoom(room.id!);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
