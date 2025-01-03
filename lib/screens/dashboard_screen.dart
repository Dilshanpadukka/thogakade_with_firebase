import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thoga_kade/providers/app_state.dart';
import 'package:thoga_kade/widgets/app_navigation_drawer.dart';
import 'package:thoga_kade/widgets/summary_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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

          final totalInventory = appState.inventory.length;
          final lowStockItems = appState.inventory.where((item) => item.quantity < 10).length;
          final todayOrders = appState.orders.where((order) => order.date.isAfter(DateTime.now().subtract(const Duration(days: 1)))).length;
          final totalRevenue = appState.orders.fold(0.0, (sum, order) => sum + order.total);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Summary',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      SummaryCard(
                        title: 'Total Inventory',
                        value: totalInventory.toString(),
                        icon: Icons.inventory,
                      ),
                      SummaryCard(
                        title: 'Low Stock Items',
                        value: lowStockItems.toString(),
                        icon: Icons.warning,
                        color: Colors.orange,
                      ),
                      SummaryCard(
                        title: 'Today\'s Orders',
                        value: todayOrders.toString(),
                        icon: Icons.shopping_cart,
                      ),
                      SummaryCard(
                        title: 'Total Revenue',
                        value: '\Rs.${totalRevenue.toStringAsFixed(2)}',
                        icon: Icons.attach_money_rounded,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

