// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:thoga_kade/providers/app_state.dart';
// import 'package:thoga_kade/widgets/app_navigation_drawer.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';
//
// class ReportsScreen extends StatelessWidget {
//   const ReportsScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reports'),
//       ),
//       drawer: const AppNavigationDrawer(),
//       body: Consumer<AppState>(
//         builder: (context, appState, child) {
//           if (appState.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (appState.error != null) {
//             return Center(
//               child: Text(
//                 appState.error ?? 'An unknown error occurred.',
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             );
//           }
//
//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Sales Report',
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.4,
//                   child: LineChart(
//                     _createSalesData(appState),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 Text(
//                   'Inventory Status',
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//                 const SizedBox(height: 16),
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.4,
//                   child: BarChart(
//                     _createInventoryData(appState),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   LineChartData _createSalesData(AppState appState) {
//     final salesData = appState.orders
//         .where((order) => order.date.isAfter(DateTime.now().subtract(const Duration(days: 30))))
//         .fold<Map<DateTime, double>>({}, (map, order) {
//       final date = DateTime(order.date.year, order.date.month, order.date.day);
//       map[date] = (map[date] ?? 0) + order.total;
//       return map;
//     });
//
//     if (salesData.isEmpty) {
//       return LineChartData(
//         lineBarsData: [],
//         titlesData: FlTitlesData(show: false),
//         borderData: FlBorderData(show: false),
//         gridData: FlGridData(show: false),
//       );
//     }
//
//     final sortedDates = salesData.keys.toList()..sort();
//
//     return LineChartData(
//       gridData: FlGridData(show: false),
//       titlesData: FlTitlesData(
//         bottomTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 22,
//           getTextStyles: (context, value) => const TextStyle(
//             color: Color(0xff68737d),
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//           ),
//           getTitles: (value) {
//             final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
//             return DateFormat('MM/dd').format(date);
//           },
//           margin: 8,
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           getTextStyles: (context, value) => const TextStyle(
//             color: Color(0xff67727d),
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//           ),
//           getTitles: (value) {
//             return '\$${value.toInt()}';
//           },
//           reservedSize: 28,
//           margin: 12,
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: Border.all(color: const Color(0xff37434d), width: 1),
//       ),
//       minX: sortedDates.first.millisecondsSinceEpoch.toDouble(),
//       maxX: sortedDates.last.millisecondsSinceEpoch.toDouble(),
//       minY: 0,
//       maxY: salesData.values.reduce((a, b) => a > b ? a : b),
//       lineBarsData: [
//         LineChartBarData(
//           spots: salesData.entries
//               .map((entry) => FlSpot(
//             entry.key.millisecondsSinceEpoch.toDouble(),
//             entry.value,
//           ))
//               .toList(),
//           isCurved: true,
//           colors: [Theme.of(context).colorScheme.primary],
//           dotData: FlDotData(show: false),
//           belowBarData: BarAreaData(show: false),
//         ),
//       ],
//     );
//   }
//
//   BarChartData _createInventoryData(AppState appState) {
//     final inventoryData = appState.inventory
//         .map((item) => MapEntry(item.name, item.quantity))
//         .toList()
//       ..sort((a, b) => b.value.compareTo(a.value));
//
//     if (inventoryData.isEmpty) {
//       return BarChartData(
//         barGroups: [],
//         titlesData: FlTitlesData(show: false),
//         borderData: FlBorderData(show: false),
//       );
//     }
//
//     return BarChartData(
//       alignment: BarChartAlignment.spaceAround,
//       maxY: inventoryData.map((e) => e.value.toDouble()).reduce((a, b) => a > b ? a : b),
//       barTouchData: BarTouchData(
//         touchTooltipData: BarTouchTooltipData(
//           tooltipBgColor: Colors.blueGrey,
//           getTooltipItem: (group, groupIndex, rod, rodIndex) {
//             return BarTooltipItem(
//               inventoryData[groupIndex].key + '\n',
//               const TextStyle(color: Colors.white),
//               children: <TextSpan>[
//                 TextSpan(
//                   text: (rod.y.round()).toString(),
//                   style: const TextStyle(
//                     color: Colors.yellow,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: SideTitles(
//           showTitles: true,
//           getTextStyles: (context, value) => const TextStyle(
//             color: Color(0xff68737d),
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//           ),
//           margin: 16,
//           getTitles: (double value) {
//             final name = inventoryData[value.toInt()].key;
//             return name.length > 3 ? name.substring(0, 3) : name;
//           },
//         ),
//         leftTitles: SideTitles(
//           showTitles: true,
//           getTextStyles: (context, value) => const TextStyle(
//             color: Color(0xff67727d),
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//           ),
//           margin: 8,
//           reservedSize: 28,
//           getTitles: (value) {
//             return value.toInt().toString();
//           },
//         ),
//       ),
//       borderData: FlBorderData(show: false),
//       barGroups: inventoryData.asMap().entries.map((entry) {
//         return BarChartGroupData(
//           x: entry.key,
//           barRods: [
//             BarChartRodData(
//               y: entry.value.value.toDouble(),
//               colors: [Colors.lightBlueAccent, Colors.greenAccent],
//             )
//           ],
//           showingTooltipIndicators: [0],
//         );
//       }).toList(),
//     );
//   }
// }
