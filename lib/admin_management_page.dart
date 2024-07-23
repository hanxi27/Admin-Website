import 'package:flutter/material.dart';
import 'dashboard/dashboard_screen.dart'; // Ensure this import is correct

class AdminManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Management'),
      ),
      body: DashboardScreen(), // Display the DashboardScreen
    );
  }
}
