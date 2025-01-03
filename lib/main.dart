import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:thoga_kade/providers/app_state.dart';
import 'package:thoga_kade/screens/dashboard_screen.dart';
import 'package:thoga_kade/screens/inventory_screen.dart';
import 'package:thoga_kade/screens/orders_screen.dart';
import 'package:thoga_kade/screens/reports_screen.dart';
import 'package:thoga_kade/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return MaterialApp(
          title: 'Thoga Kade',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: appState.themeMode, // Updated for proper theme switching
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: '/',
          routes: {
            '/': (context) => const DashboardScreen(),
            '/inventory': (context) => const InventoryScreen(),
            '/orders': (context) => const OrdersScreen(),
            // '/reports': (context) => const ReportsScreen(),
          },
        );
      },
    );
  }
}
