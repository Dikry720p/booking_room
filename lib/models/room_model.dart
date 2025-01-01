import 'category_model.dart';

class RoomModel {
  final int id;
  final String name;
  final int categoryId;
  final int price;
  final int capacity;
  final String description;
  final String? image;
  final String status;
  final String createdAt;
  final String updatedAt;
  final CategoryModel? category;

  RoomModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.capacity,
    required this.description,
    this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      categoryId: json['categoryId'] ?? 0,
      price: json['price'] ?? 0,
      capacity: json['capacity'] ?? 0,
      description: json['description'] ?? '',
      image: json['image'],
      status: json['status'] ?? 'draft',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
      'price': price,
      'capacity': capacity,
      'description': description,
      'image': image,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'category': category?.toJson(),
    };
  }
}
