import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class TopProductsPieChart extends StatelessWidget {
  final String userId;

  const TopProductsPieChart({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('purchase_history')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No purchase history available.'));
        }

        var purchaseHistory = snapshot.data!.docs;

        // Count occurrences of each product
        Map<String, int> productCount = {};
        int totalCount = 0;
        for (var purchase in purchaseHistory) {
          var items = List<Map<String, dynamic>>.from(purchase['items']);
          for (var item in items) {
            var title = item['title'] ?? 'Unknown';
            int quantity = item['quantity'] as int;
            productCount[title] = (productCount[title] ?? 0) + quantity;
            totalCount += quantity;
          }
        }

        // Sort products by count and take the top 5
        var sortedProducts = productCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        var topProducts = sortedProducts.take(5).toList();

        // Colors for each section
        final colors = [
          Colors.blue,
          Colors.green,
          Colors.orange,
          Colors.purple,
          Colors.red,
        ];

        // Prepare data for the pie chart
        List<PieChartSectionData> pieChartSections = topProducts.asMap().entries.map((entry) {
          int index = entry.key;
          var product = entry.value;
          double percentage = (product.value / totalCount) * 100;

          return PieChartSectionData(
            value: product.value.toDouble(),
            title: '${percentage.toStringAsFixed(1)}%', // Display the percentage
            radius: 50.0,
            color: colors[index],
            titleStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 300, // Set a fixed height for the pie chart
                child: PieChart(
                  PieChartData(
                    sections: pieChartSections,
                    centerSpaceRadius: 40.0,
                    sectionsSpace: 2.0,
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                        // Optionally handle touch interaction
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              // Legend
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: topProducts.asMap().entries.map((entry) {
                  int index = entry.key;
                  var product = entry.value;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        color: colors[index],
                      ),
                      SizedBox(width: 8),
                      Text('${product.key} (${product.value})', style: TextStyle(fontSize: 14)),
                    ],
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
