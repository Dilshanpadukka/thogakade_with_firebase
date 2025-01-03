import 'package:flutter/material.dart';
import 'package:thoga_kade/models/inventory_item.dart';

class InventoryItemCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const InventoryItemCard({
    Key? key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: item.imageUrl != null
            ? Image.network(
          item.imageUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        )
            : const Icon(Icons.image, size: 50),
        title: Text(item.name),
        subtitle: Text('Price: \Rs.${item.price.toStringAsFixed(2)} | Quantity: ${item.quantity} KG'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

