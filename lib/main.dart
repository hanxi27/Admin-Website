import 'package:flutter/foundation.dart'; // Import this to use kIsWeb
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'admin_homepage.dart';
import 'Customer_Support/customer_support_page.dart' as customer_support;
import 'Map/map_page.dart' as map_page;
import 'Stock_Inventory/stock_inventory_page.dart' as stock_inventory;
import 'Customer_Detail/customer_details_page.dart' as customer_detail;
import 'login_page.dart';
import 'firebase_options.dart'; // Ensure this file exists
import 'dashboard/dashboard_screen.dart'; // Import the dashboard screen
import 'dashboard/revenue.dart'; // Import the revenue screen
import 'Customer_Support/message_provider.dart'; // Import the message provider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp();
    }
    runApp(MyApp());
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageProvider()), // Provide MessageProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Retail Store',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/admin_homepage': (context) => AdminHomepage(),
          '/map': (context) => map_page.MapPage(coordinates: '(0.0, 0.0)'), // Provide default coordinates
          '/customersupport': (context) => customer_support.CustomerSupportPage(),
          '/stock_inventory': (context) => stock_inventory.StockInventoryPage(),
          '/customer_details': (context) => customer_detail.CustomerDetailsPage(),
          '/dashboard': (context) => DashboardScreen(), // Add the dashboard route
          '/revenue': (context) => RevenueScreen(), // Add the revenue route
        },
        navigatorObservers: <NavigatorObserver>[observer],
      ),
    );
  }
}