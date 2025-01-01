import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({Key? key}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  final RoomService _roomService = RoomService();
  List<RoomModel> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      // TODO: Ganti dengan cara mengambil token yang tersimpan
      const String token = 'YOUR_STORED_TOKEN';
      final rooms = await _roomService.getRooms(token);
      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _showRoomDialog([RoomModel? room]) async {
    final nameController = TextEditingController(text: room?.name);
    final categoryIdController =
        TextEditingController(text: room?.categoryId.toString());
    final priceController = TextEditingController(text: room?.price.toString());
    final capacityController =
        TextEditingController(text: room?.capacity.toString());
    final descriptionController =
        TextEditingController(text: room?.description);

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(room == null ? 'Tambah Ruangan' : 'Edit Ruangan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Ruangan'),
              ),
              TextField(
                controller: categoryIdController,
                decoration: const InputDecoration(labelText: 'ID Kategori'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: capacityController,
                decoration: const InputDecoration(labelText: 'Kapasitas'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              try {
                const String token = 'YOUR_STORED_TOKEN';
                final newRoom = RoomModel(
                  name: nameController.text,
                  categoryId: int.parse(categoryIdController.text),
                  price: int.parse(priceController.text),
                  capacity: int.parse(capacityController.text),
                  description: descriptionController.text,
                );

                if (room == null) {
                  await _roomService.createRoom(token, newRoom);
                } else {
                  await _roomService.updateRoom(token, room.id!, newRoom);
                }

                if (mounted) {
                  Navigator.pop(context);
                  _loadRooms();
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRooms,
              child: ListView.builder(
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  final room = _rooms[index];
                  return ListTile(
                    title: Text(room.name),
                    subtitle: Text('Kapasitas: ${room.capacity}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showRoomDialog(room),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text('Hapus ruangan ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              const String token = 'YOUR_STORED_TOKEN';
                              await _roomService.deleteRoom(token, room.id!);
                              _loadRooms();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRoomDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
