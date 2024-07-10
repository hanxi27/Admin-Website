import 'package:flutter/material.dart';
import 'Map/map_page.dart' as map_page;
import 'Customer_Support/customer_support_page.dart' as customer_support;
import 'Stock_Inventory/stock_inventory_page.dart' as stock_inventory;
import 'Customer_Detail/customer_details_page.dart' as customer_detail;
import 'admin_management_page.dart';

class AdminHomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Homepage'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map), text: 'Map'),
              Tab(icon: Icon(Icons.help), text: 'Customer Support'),
              Tab(icon: Icon(Icons.inventory), text: 'Stock Inventory'),
              Tab(icon: Icon(Icons.person), text: 'Customer Details'),
              Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admin Management'), // New tab for Admin Management
            ],
          ),
        ),
        body: TabBarView(
          children: [
            map_page.MapPage(),
            customer_support.CustomerSupportPage(),
            stock_inventory.StockInventoryPage(),
            customer_detail.CustomerDetailsPage(),
            AdminManagementPage(), // New Admin Management Page
          ],
        ),
      ),
    );
  }
}
