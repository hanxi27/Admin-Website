import 'package:flutter/material.dart';
import 'login_page.dart';
import 'admin_homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Retail Store',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // Add this line
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/admin_homepage': (context) => AdminHomepage(),
        '/map': (context) => MapPage(),
        '/request_help': (context) => RequestHelpPage(),
        '/stock_inventory': (context) => StockInventoryPage(),
        '/customer_details': (context) => CustomerDetailsPage(),
      },
    );
  }
}
