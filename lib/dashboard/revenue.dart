import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class RevenueScreen extends StatefulWidget {
  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  double totalRevenue = 0.0;
  Map<DateTime, double> dailyRevenue = {};
  Map<String, double> monthlyRevenue = {};
  double selectedValue = 0.0;
  String selectedYear = '2024'; // Default to 2024
  String selectedMonth = '08'; // Default to August

  @override
  void initState() {
    super.initState();
    fetchRevenue();
  }

  Future<void> fetchRevenue() async {
    double revenue = 0.0;
    QuerySnapshot purchaseSnapshot = await FirebaseFirestore.instance.collection('purchase_history').get();

    for (var purchaseDoc in purchaseSnapshot.docs) {
      double purchasePrice = double.parse(purchaseDoc['totalPrice'].toString());
      revenue += purchasePrice;

      Timestamp timestamp = purchaseDoc['timestamp'];
      DateTime purchaseDate = timestamp.toDate();

      // Daily revenue
      DateTime day = DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day);
      dailyRevenue[day] = (dailyRevenue[day] ?? 0.0) + purchasePrice;

      // Monthly revenue
      String month = DateFormat('yyyy-MM').format(purchaseDate);
      monthlyRevenue[month] = (monthlyRevenue[month] ?? 0.0) + purchasePrice;
    }

    setState(() {
      totalRevenue = revenue;
    });
  }

  List<BarChartGroupData> _buildDailyRevenueChart() {
    List<BarChartGroupData> barGroups = [];

    // Sort the dailyRevenue keys (dates) in ascending order
    var sortedKeys = dailyRevenue.keys.toList()..sort();

    for (var date in sortedKeys) {
      if (DateFormat('yyyy-MM').format(date) == '$selectedYear-$selectedMonth') {
        barGroups.add(
          BarChartGroupData(
            x: date.day,
            barRods: [
              BarChartRodData(
                toY: dailyRevenue[date]!,
                color: Colors.lightBlueAccent,
                width: 20, // Increased bar width
              ),
            ],
          ),
        );
      }
    }

    return barGroups;
  }

  List<BarChartGroupData> _buildMonthlyRevenueChart() {
    List<BarChartGroupData> barGroups = [];

    // Create a map to store revenue for each month
    Map<int, double> revenuePerMonth = {};

    // Initialize each month with 0 revenue
    for (int i = 1; i <= 12; i++) {
      revenuePerMonth[i] = 0.0;
    }

    // Populate the map with actual monthly revenue
    monthlyRevenue.forEach((month, revenue) {
      if (month.startsWith(selectedYear)) {
        int monthIndex = int.parse(month.split('-')[1]);
        revenuePerMonth[monthIndex] = revenue;
      }
    });

    // Create BarChartGroupData in the correct order
    for (int i = 1; i <= 12; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: revenuePerMonth[i] ?? 0.0,
              color: Colors.lightGreenAccent,
              width: 20, // Increased bar width
            ),
          ],
        ),
      );
    }

    return barGroups;
  }

  List<Widget> _buildMonthButtons() {
    List<String> months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months.map((month) {
      int monthIndex = months.indexOf(month) + 1;
      String formattedMonth = monthIndex.toString().padLeft(2, '0');
      return ElevatedButton(
        onPressed: () {
          setState(() {
            selectedMonth = formattedMonth;
          });
        },
        child: Text(month),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              selectedMonth == formattedMonth ? Colors.orange : Colors.grey),
        ),
      );
    }).toList();
  }

  String _formatDate(int day) {
    return DateFormat('d').format(DateTime(0, 1, day));
  }

  String _formatMonth(int month) {
    return DateFormat('MMM').format(DateTime(0, month));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monthly and Daily Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Revenue: RM ${totalRevenue.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
              Text('Selected Revenue: RM ${selectedValue.toStringAsFixed(2)}', style: TextStyle(color: Colors.red, fontSize: 18)),
              SizedBox(height: 20),
              Text('Selected Year:', style: TextStyle(fontSize: 18)),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedYear = '2024';
                      });
                    },
                    child: Text('2024',),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          selectedYear == '2024' ? Colors.orange : Colors.grey),
                    ),
                  ),
                  // Add more buttons for other years as needed
                ],
              ),
              SizedBox(height: 20),
              Text('Select Month:', style: TextStyle(fontSize: 18)),
              SizedBox(
                height: 35,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _buildMonthButtons(),
                ),
              ),
              SizedBox(height: 20),
              Text('Daily Revenue', style: TextStyle(fontSize: 18)),
              Column(
                children: [
                  SizedBox(
                    height: 450,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16.0), // Add padding to the left and top to avoid overlap
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: _buildDailyRevenueChart(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 60, // Increase reservedSize to prevent overlap
                                getTitlesWidget: (value, meta) {
                                  // Do not show the highest value on the y-axis
                                  if (value == dailyRevenue.values.reduce((a, b) => a > b ? a : b)) {
                                    return Container();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0), // Add space between label and chart
                                    child: Text(value.toInt().toString()),
                                  );
                                },
                              ),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text(_formatDate(value.toInt()));
                                },
                              ),
                            ),
                          ),
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              tooltipPadding: const EdgeInsets.all(8),
                              tooltipRoundedRadius: 8,
                              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                return BarTooltipItem(
                                  rod.toY.toStringAsFixed(2),
                                  TextStyle(color: Colors.white),
                                );
                              },
                            ),
                            touchCallback: (FlTouchEvent event, barTouchResponse) {
                              if (event is FlTapUpEvent && barTouchResponse?.spot != null) {
                                setState(() {
                                  selectedValue = barTouchResponse!.spot!.touchedRodData.toY;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2), // Reduce space between chart and label
                  Text(
                    'Day',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Make the text smaller
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Monthly Revenue', style: TextStyle(fontSize: 18)),
              SizedBox(
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 16.0), // Add padding to the left and top to avoid overlap
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: _buildMonthlyRevenueChart(),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60, // Increase reservedSize to prevent overlap
                            getTitlesWidget: (value, meta) {
                              // Do not show the highest value on the y-axis
                              if (value == monthlyRevenue.values.reduce((a, b) => a > b ? a : b)) {
                                return Container();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0), // Add space between label and chart
                                child: Text(value.toInt().toString()),
                              );
                            },
                          ),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(_formatMonth(value.toInt()));
                            },
                          ),
                        ),
                      ),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipPadding: const EdgeInsets.all(8),
                          tooltipRoundedRadius: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              rod.toY.toStringAsFixed(2),
                              TextStyle(color: Colors.white),
                            );
                          },
                        ),
                        touchCallback: (FlTouchEvent event, barTouchResponse) {
                          if (event is FlTapUpEvent && barTouchResponse?.spot != null) {
                            setState(() {
                              selectedValue = barTouchResponse!.spot!.touchedRodData.toY;
                            });
                          }
                        },
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
