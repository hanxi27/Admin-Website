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
    
    int otherQuantity = 0;
    if (sortedCategories.length > 5) {
      otherQuantity = sortedCategories.sublist(5).fold(0, (sum, item) => sum + item['quantity'] as int);
      sortedCategories = sortedCategories.take(5).toList();
      sortedCategories.add({'name': 'Others', 'quantity': otherQuantity});
    }
    
    setState(() {
      topCategories = sortedCategories;
    });
  }

  List<PieChartSectionData> _buildTopCategoriesChart() {
    int total = topCategories.fold(0, (sum, item) => sum + (item['quantity'] as int));
    return topCategories.map((entry) {
      double percentage = (entry['quantity'] / total) * 100;
      return PieChartSectionData(
        color: _getColor(entry['name']),
        value: percentage,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 100,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();
  }

  Color _getColor(String category) {
    switch (category) {
      case 'Hair Care':
        return Colors.blue;
      case 'Nutrition':
        return Color.fromARGB(255, 67, 55, 67);
      case 'Make Up':
        return Colors.green;
      case 'Groceries':
        return Colors.yellow;
      case 'Pets Care':
        return Colors.orange;
      case 'Supplement':
        return Color.fromARGB(255, 205, 70, 209);
      case 'Tonic':
        return Color.fromARGB(255, 16, 180, 202);
      case 'Foot Treatment':
        return Color.fromARGB(255, 176, 39, 55);
      case 'Traditional Medicine':
        return Color.fromARGB(255, 43, 205, 28);
      case 'Coffee':
        return Color.fromARGB(255, 176, 128, 39);
      case 'Dairy Product':
        return Color.fromARGB(255, 39, 41, 176);
      case 'Others':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: topCategories.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: _getColor(entry['name']),
              ),
              SizedBox(width: 8),
              Text(entry['name']),
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
