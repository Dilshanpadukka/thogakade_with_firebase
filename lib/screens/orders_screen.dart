import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoga_kade/providers/app_state.dart';
import 'package:thoga_kade/widgets/app_navigation_drawer.dart';
import 'package:thoga_kade/widgets/order_card.dart';
import 'package:thoga_kade/screens/order_form_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
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
            itemCount: appState.orders.length,
            itemBuilder: (context, index) {
              final order = appState.orders[index];
              return OrderCard(
                order: order,
                onTap: () {
                  // TODO: Implement order details screen
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
              builder: (context) => const OrderFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

