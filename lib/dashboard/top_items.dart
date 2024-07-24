import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class TopItemsScreen extends StatefulWidget {
  @override
  _TopItemsScreenState createState() => _TopItemsScreenState();
}

class _TopItemsScreenState extends State<TopItemsScreen> {
  List<Map<String, dynamic>> topItems = [];
  Map<String, int> topCategories = {};
  int touchedIndexTopItems = -1;
  int touchedIndexTopCategories = -1;

  @override
  void initState() {
    super.initState();
    fetchTopItems();
    fetchTopCategories();
  }

  Future<void> fetchTopItems() async {
    Map<String, int> itemQuantities = {};
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('purchase_history').get();
    for (var purchaseDoc in querySnapshot.docs) {
      List<dynamic> items = purchaseDoc['items'];
      for (var item in items) {
        String itemName = item['title'];
        int quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1; // Ensure quantity is an integer
        itemQuantities[itemName] = (itemQuantities[itemName] ?? 0) + quantity;
      }
    }
    List<Map<String, dynamic>> sortedItems = itemQuantities.entries
        .map((entry) => {'name': entry.key, 'quantity': entry.value})
        .toList()
      ..sort((a, b) => (b['quantity'] as int).compareTo(a['quantity'] as int));
    setState(() {
      topItems = sortedItems.take(10).toList();
    });
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
    setState(() {
      topCategories = categoryQuantities;
    });
  }

  List<BarChartGroupData> _buildTopItemsChart() {
    return topItems.asMap().entries.map((entry) {
      int index = entry.key;
      String name = entry.value['name'];
      int quantity = entry.value['quantity'];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: quantity.toDouble(),
            color: Colors.lightBlueAccent,
            width: 20,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: false,
            ),
          )
        ],
        showingTooltipIndicators: touchedIndexTopItems == index ? [0] : [],
      );
    }).toList();
  }

  List<BarChartGroupData> _buildTopCategoriesChart() {
    return topCategories.entries.map((entry) {
      String category = entry.key;
      int quantity = entry.value;
      return BarChartGroupData(
        x: topCategories.keys.toList().indexOf(category),
        barRods: [
          BarChartRodData(
            toY: quantity.toDouble(),
            color: Colors.lightGreenAccent,
            width: 20,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: false,
            ),
          )
        ],
        showingTooltipIndicators: touchedIndexTopCategories == topCategories.keys.toList().indexOf(category) ? [0] : [],
      );
    }).toList();
  }

  Widget _buildBarChart({
    required List<BarChartGroupData> barGroups,
    required String title,
    required Function(FlTouchEvent, BarTouchResponse?) touchCallback,
  }) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipPadding: const EdgeInsets.all(8),
              tooltipRoundedRadius: 8,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  rod.toY.toString(),
                  TextStyle(color: Colors.white),
                );
              },
            ),
            touchCallback: touchCallback,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  return Text('');
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 100,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < barGroups.length) {
                    String titleName;
                    if (title == 'Top 10 Products') {
                      titleName = topItems[value.toInt()]['name'];
                    } else {
                      titleName = topCategories.keys.toList()[value.toInt()];
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          titleName.length > 10
                              ? '${titleName.substring(0, 10)}...'
                              : titleName,
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                  return Text('');
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Top 10 Products', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildBarChart(
                barGroups: _buildTopItemsChart(),
                title: 'Top 10 Products',
                touchCallback: (FlTouchEvent event, BarTouchResponse? barTouchResponse) {
                  setState(() {
                    if (event.isInterestedForInteractions && barTouchResponse != null && barTouchResponse.spot != null) {
                      touchedIndexTopItems = barTouchResponse.spot!.touchedBarGroupIndex;
                    } else {
                      touchedIndexTopItems = -1;
                    }
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Top Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildBarChart(
                barGroups: _buildTopCategoriesChart(),
                title: 'Top Categories',
                touchCallback: (FlTouchEvent event, BarTouchResponse? barTouchResponse) {
                  setState(() {
                    if (event.isInterestedForInteractions && barTouchResponse != null && barTouchResponse.spot != null) {
                      touchedIndexTopCategories = barTouchResponse.spot!.touchedBarGroupIndex;
                    } else {
                      touchedIndexTopCategories = -1;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
