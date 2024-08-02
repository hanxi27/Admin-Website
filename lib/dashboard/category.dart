import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class TopCategoriesWidget extends StatefulWidget {
  @override
  _TopCategoriesWidgetState createState() => _TopCategoriesWidgetState();
}

class _TopCategoriesWidgetState extends State<TopCategoriesWidget> {
  List<Map<String, dynamic>> topCategories = [];
  int touchedIndexTopCategories = -1;
  final List<Color> categoryColors = [
    Colors.red,
    Colors.orange,
    Colors.blue,
    Colors.purple,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
    fetchTopCategories();
  }

  Future<void> fetchTopCategories() async {
    Map<String, int> categoryQuantities = {};
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('purchase_history').get();
    for (var purchaseDoc in querySnapshot.docs) {
      List<dynamic> items = purchaseDoc['items'];
      for (var item in items) {
        String category = item['category'];
        categoryQuantities[category] = (categoryQuantities[category] ?? 0) + 1;
      }
    }
    List<Map<String, dynamic>> sortedCategories = categoryQuantities.entries
        .map((entry) => {'name': entry.key, 'quantity': entry.value})
        .toList()
      ..sort((a, b) => (b['quantity'] as int).compareTo(a['quantity'] as int));
    setState(() {
      topCategories = sortedCategories.take(5).toList();
    });
  }

  List<PieChartSectionData> _buildTopCategoriesChart() {
    int total = topCategories.fold(0, (sum, item) => sum + item['quantity'] as int);
    return topCategories.asMap().entries.map((entry) {
      int index = entry.key;
      double percentage = (entry.value['quantity'] / total) * 100;
      return PieChartSectionData(
        color: categoryColors[index],
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: topCategories.asMap().entries.map((entry) {
        int index = entry.key;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: categoryColors[index],
              ),
              SizedBox(width: 8),
              Text(entry.value['name']),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Top 5 Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: _buildTopCategoriesChart(),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (event.isInterestedForInteractions && pieTouchResponse != null && pieTouchResponse.touchedSection != null) {
                              touchedIndexTopCategories = pieTouchResponse.touchedSection!.touchedSectionIndex;
                            } else {
                              touchedIndexTopCategories = -1;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: _buildLegend(),
          ),
        ],
      ),
    );
  }
}
