import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoga_kade/models/inventory_item.dart';
import 'package:thoga_kade/providers/app_state.dart';

class InventoryFormScreen extends StatefulWidget {
  final InventoryItem? item;

  const InventoryFormScreen({Key? key, this.item}) : super(key: key);

  @override
  _InventoryFormScreenState createState() => _InventoryFormScreenState();
}

class _InventoryFormScreenState extends State<InventoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late double _price;
  late int _quantity;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _name = widget.item!.name;
      _price = widget.item!.price;
      _quantity = widget.item!.quantity;
      _imageUrl = widget.item!.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Add Inventory Item' : 'Edit Inventory Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: widget.item?.name,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) => _name = value!,
            ),
            TextFormField(
              initialValue: widget.item?.price.toString(),
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) => _price = double.parse(value!),
            ),
            TextFormField(
              initialValue: widget.item?.quantity.toString(),
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) => _quantity = int.parse(value!),
            ),
            TextFormField(
              initialValue: widget.item?.imageUrl,
              decoration: const InputDecoration(labelText: 'Image URL (optional)'),
              onSaved: (value) => _imageUrl = value,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.item == null ? 'Add Item' : 'Update Item'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final appState = Provider.of<AppState>(context, listen: false);

      try {
        if (widget.item == null) {
          await appState.addInventoryItem(
            InventoryItem(
              id: '',
              name: _name,
              price: _price,
              quantity: _quantity,
              imageUrl: _imageUrl,
            ),
          );
        } else {
          await appState.updateInventoryItem(
            InventoryItem(
              id: widget.item!.id,
              name: _name,
              price: _price,
              quantity: _quantity,
              imageUrl: _imageUrl,
            ),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}

