import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart'; // Ensure this import exists

class AdminManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Management'),
        automaticallyImplyLeading: false, // This line removes the back button
      ),
      body: DashboardScreen(), // Display the DashboardScreen
    );
  }
}
