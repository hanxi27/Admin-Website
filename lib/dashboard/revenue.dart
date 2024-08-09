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
  String selectedMonth = '07'; // Default to July

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
    dailyRevenue.forEach((date, revenue) {
      if (DateFormat('yyyy-MM').format(date) == '$selectedYear-$selectedMonth') {
        barGroups.add(
          BarChartGroupData(
            x: date.day,
            barRods: [
              BarChartRodData(
                toY: revenue, 
                color: Colors.lightBlueAccent,
                width: 20, // Increased bar width
              ),
            ],
          ),
        );
      }
    });
    return barGroups;
  }

  List<BarChartGroupData> _buildMonthlyRevenueChart() {
    List<BarChartGroupData> barGroups = [];
    monthlyRevenue.forEach((month, revenue) {
      if (month.startsWith(selectedYear)) {
        int monthIndex = int.parse(month.split('-')[1]);
        barGroups.add(
          BarChartGroupData(
            x: monthIndex,
            barRods: [
              BarChartRodData(
                toY: revenue, 
                color: Colors.lightGreenAccent,
                width: 20, // Increased bar width
              ),
            ],
          ),
        );
      }
    });
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
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barGroups: _buildDailyRevenueChart(),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                if (value == 0) return Text('0');
                                if (value == 500) return Text('500');
                                if (value == 1000) return Text('1K');
                                return Container();
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
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: _buildMonthlyRevenueChart(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return Text('0');
                            if (value == 500) return Text('500');
                            if (value == 1000) return Text('1K');
                            if (value == 1500) return Text('1.5K');
                            if (value == 2000) return Text('2K');
                            if (value == 2300) return Text('2.3K');
                            return Container();
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
            ],
          ),
        ),
      ),
    );
  }
}
