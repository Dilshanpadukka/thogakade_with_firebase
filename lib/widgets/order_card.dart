import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thoga_kade/models/order.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Order #${order.id.substring(0, 8)}'),
        subtitle: Text(
          'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(order.date)}\n'
              'Total: \Rs.${order.total.toStringAsFixed(2)}',
        ),
        trailing: Chip(
          label: Text(order.status),
          backgroundColor: _getStatusColor(order.status),
        ),
        onTap: onTap,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

