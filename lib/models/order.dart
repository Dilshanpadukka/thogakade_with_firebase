import 'package:thoga_kade/models/inventory_item.dart';

class Order {
  final String id;
  final List<OrderItem> items;
  final double total;
  final DateTime date;
  final String status;

  Order({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
  });

  factory Order.fromJson(String id, Map<dynamic, dynamic> json) {
    return Order(
      id: id,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      total: (json['total'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}

class OrderItem {
  final InventoryItem item;
  final int quantity;

  OrderItem({
    required this.item,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<dynamic, dynamic> json) {
    return OrderItem(
      item: InventoryItem.fromJson(json['itemId'], json['item']),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': item.id,
      'item': item.toJson(),
      'quantity': quantity,
    };
  }
}

