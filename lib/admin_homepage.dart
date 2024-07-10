import 'package:flutter/material.dart';

class AdminHomepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Homepage'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map), text: 'Map'),
              Tab(icon: Icon(Icons.help), text: 'Customer Support'),
              Tab(icon: Icon(Icons.inventory), text: 'Stock Inventory'),
              Tab(icon: Icon(Icons.person), text: 'Customer Details'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MapPage(),
            CustomerSupportPage(),
            StockInventoryPage(),
            CustomerDetailsPage(),
          ],
        ),
      ),
    );
  }
}

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Map Page'),
    );
  }
}

class CustomerSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Customer Support Page'),
    );
  }
}

class StockInventoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Stock Inventory Page'),
    );
  }
}

class CustomerDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Customer Details Page'),
    );
  }
}
