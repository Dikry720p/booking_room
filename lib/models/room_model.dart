class CategoryModel {
  final int id;
  final String name;
  final String? description;
  final String createdAt;
  final String updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class RoomModel {
  final int? id;
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
    this.id,
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
      id: json['id'],
      name: json['name'],
      categoryId: json['categoryId'],
      price: json['price'],
      capacity: json['capacity'],
      description: json['description'],
      image: json['image'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categoryId': categoryId,
      'price': price,
      'capacity': capacity,
      'description': description,
    };
  }
}
