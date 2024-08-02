import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class TopItemsWidget extends StatefulWidget {
  @override
  _TopItemsWidgetState createState() => _TopItemsWidgetState();
}

class _TopItemsWidgetState extends State<TopItemsWidget> {
  List<Map<String, dynamic>> topItems = [];
  int touchedIndexTopItems = -1;

  @override
  void initState() {
    super.initState();
    fetchTopItems();
  }

  Future<void> fetchTopItems() async {
    Map<String, int> itemQuantities = {};
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('purchase_history').get();
    for (var purchaseDoc in querySnapshot.docs) {
      List<dynamic> items = purchaseDoc['items'];
      for (var item in items) {
        String itemName = item['title'];
        int quantity = int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;
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
                    String titleName = topItems[value.toInt()]['name'];
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
        ],
      ),
    );
  }
}
