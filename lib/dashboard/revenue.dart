import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class RevenueScreen extends StatefulWidget {
  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  double totalRevenue = 0.0;
  Map<DateTime, double> dailyRevenue = {};
  Map<String, double> monthlyRevenue = {};

  @override
  void initState() {
    super.initState();
    fetchRevenue();
  }

  Future<void> fetchRevenue() async {
    double revenue = 0.0;
    QuerySnapshot purchaseSnapshot = await FirebaseFirestore.instance.collection('purchase_history').get();
    
    for (var purchaseDoc in purchaseSnapshot.docs) {
      double purchasePrice = purchaseDoc['totalPrice'];
      revenue += purchasePrice;
      
      Timestamp timestamp = purchaseDoc['timestamp'];
      DateTime purchaseDate = timestamp.toDate();
      
      // Daily revenue
      DateTime day = DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day);
      dailyRevenue[day] = (dailyRevenue[day] ?? 0.0) + purchasePrice;
      
      // Monthly revenue
      String month = "${purchaseDate.year}-${purchaseDate.month.toString().padLeft(2, '0')}";
      monthlyRevenue[month] = (monthlyRevenue[month] ?? 0.0) + purchasePrice;
    }
    
    setState(() {
      totalRevenue = revenue;
    });
  }

  List<BarChartGroupData> _buildDailyRevenueChart() {
    List<BarChartGroupData> barGroups = [];
    dailyRevenue.forEach((date, revenue) {
      barGroups.add(
        BarChartGroupData(
          x: date.day,
          barRods: [
            BarChartRodData(toY: revenue, color: Colors.lightBlueAccent),
          ],
        ),
      );
    });
    return barGroups;
  }

  List<BarChartGroupData> _buildMonthlyRevenueChart() {
    List<BarChartGroupData> barGroups = [];
    monthlyRevenue.forEach((month, revenue) {
      int monthIndex = int.parse(month.split('-')[1]);
      barGroups.add(
        BarChartGroupData(
          x: monthIndex,
          barRods: [
            BarChartRodData(toY: revenue, color: Colors.lightGreenAccent),
          ],
        ),
      );
    });
    return barGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Revenue: RM ${totalRevenue.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              SizedBox(height: 20),
              Text('Daily Revenue', style: TextStyle(fontSize: 18)),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _buildDailyRevenueChart(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return Text('0');
                            if (value == 500) return Text('500');
                            if (value == 1000) return Text('1K');
                            return Container();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text('Monthly Revenue', style: TextStyle(fontSize: 18)),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _buildMonthlyRevenueChart(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return Text('0');
                            if (value == 500) return Text('500');
                            if (value == 1000) return Text('1K');
                            if (value == 1500) return Text('1.5K');
                            if (value == 2000) return Text('2K');
                            return Container();
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (value, meta) {
                            return Text('${value.toInt()}');
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
