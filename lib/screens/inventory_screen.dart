import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoga_kade/providers/app_state.dart';
import 'package:thoga_kade/widgets/app_navigation_drawer.dart';
import 'package:thoga_kade/widgets/inventory_item_card.dart';
import 'package:thoga_kade/screens/inventory_form_screen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      drawer: const AppNavigationDrawer(),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (appState.error != null) {
            return Center(child: Text('Error: ${appState.error}'));
          }

          return ListView.builder(
            itemCount: appState.inventory.length,
            itemBuilder: (context, index) {
              final item = appState.inventory[index];
              return InventoryItemCard(
                item: item,
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InventoryFormScreen(item: item),
                    ),
                  );
                },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Delete'),
                      content: Text('Are you sure you want to delete ${item.name}?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await appState.deleteInventoryItem(item.id);
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InventoryFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

