class InventoryItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  InventoryItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  factory InventoryItem.fromJson(String id, Map<dynamic, dynamic> json) {
    return InventoryItem(
      id: id,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}

