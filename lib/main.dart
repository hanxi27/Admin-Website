import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin_homepage.dart';
import 'Customer_Support/customer_support_page.dart' as customer_support;
import 'Map/map_page.dart' as map_page;
import 'Stock_Inventory/stock_inventory_page.dart' as stock_inventory;
import 'Customer_Detail/customer_details_page.dart' as customer_detail;
import 'login_page.dart';
import 'firebase_options.dart'; // Make sure this import exists

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Retail Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/admin_homepage': (context) => AdminHomepage(),
        '/map': (context) => map_page.MapPage(),
        '/customersupport': (context) => customer_support.CustomerSupportPage(),
        '/stock_inventory': (context) => stock_inventory.StockInventoryPage(),
        '/customer_details': (context) => customer_detail.CustomerDetailsPage(),
      },
    );
  }
}
