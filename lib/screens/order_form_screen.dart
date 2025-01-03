import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoga_kade/models/inventory_item.dart';
import 'package:thoga_kade/models/order.dart';
import 'package:thoga_kade/providers/app_state.dart';

class OrderFormScreen extends StatefulWidget {
  const OrderFormScreen({Key? key}) : super(key: key);

  @override
  _OrderFormScreenState createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<OrderItem> _orderItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _orderItems.length + 1,
                itemBuilder: (context, index) {
                  if (index == _orderItems.length) {
                    return ListTile(
                      title: const Text('Add Item'),
                      leading: const Icon(Icons.add),
                      onTap: _addOrderItem,
                    );
                  }
                  return _buildOrderItemTile(_orderItems[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _submitOrder,
                child: const Text('Submit Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemTile(OrderItem orderItem) {
    return ListTile(
      title: Text(orderItem.item.name),
      subtitle: Text('Quantity: ${orderItem.quantity}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          setState(() {
            _orderItems.remove(orderItem);
          });
        },
      ),
    );
  }

  void _addOrderItem() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final selectedItem = await showDialog<InventoryItem>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Item'),
          children: appState.inventory.map((item) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, item);
              },
              child: Text(item.name),
            );
          }).toList(),
        );
      },
    );

    if (selectedItem != null) {
      final quantity = await showDialog<int>(
        context: context,
        builder: (context) {
          int? _quantity;
          return AlertDialog(
            title: const Text('Enter Quantity'),
            content: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _quantity = int.tryParse(value);
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, _quantity);
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );

      if (quantity != null && quantity > 0) {
        setState(() {
          _orderItems.add(OrderItem(item: selectedItem, quantity: quantity));
        });
      }
    }
  }

  void _submitOrder() async {
    if (_formKey.currentState!.validate() && _orderItems.isNotEmpty) {
      final appState = Provider.of<AppState>(context, listen: false);

      final newOrder = Order(
        id: '',
        items: _orderItems,
        total: _orderItems.fold(0, (sum, item) => sum + (item.item.price * item.quantity)),
        date: DateTime.now(),
        status: 'Pending',
      );

      try {
        await appState.addOrder(newOrder);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item to the order')),
      );
    }
  }
}

