class RoomModel {
  final int? id;
  final String name;
  final int categoryId;
  final int price;
  final int capacity;
  final String description;

  RoomModel({
    this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.capacity,
    required this.description,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      id: json['id'],
      name: json['name'],
      categoryId: json['id'],
      price: json['price'],
      capacity: json['capacity'],
      description: json['description'],
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
