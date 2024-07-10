import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'admin_homepage.dart';
import 'Customer_Support/customer_support_page.dart' as customer_support;
import 'Map/map_page.dart' as map_page;
import 'Stock_Inventory/stock_inventory_page.dart' as stock_inventory;
import 'Customer_Detail/customer_details_page.dart' as customer_detail;
import 'admin_management_page.dart'; // New import for Admin Management Page
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyBMEUQ8XN3FjIWqU98RK0td9euIj_227E",
          authDomain: "smart-retail-app-4b6a5.firebaseapp.com",
          projectId: "smart-retail-app-4b6a5",
          storageBucket: "smart-retail-app-4b6a5.appspot.com",
          messagingSenderId: "396405032929",
          appId: "1:396405032929:web:6b642e7dcb02cbe91434a0",
        ),
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
        '/admin_management': (context) => AdminManagementPage(), // New route for Admin Management Page
      },
    );
  }
}
