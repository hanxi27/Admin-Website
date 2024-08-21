import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the charting library
import 'gender.dart';
import 'age.dart';
import 'items.dart';
import 'category.dart';
import 'customer_time_spent_screen.dart'; // Import the CustomerTimeSpentScreen
import 'details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    fetchRevenue();
  }

  Future<void> fetchRevenue() async {
    double revenue = 0.0;
    QuerySnapshot purchaseSnapshot = await FirebaseFirestore.instance.collection('purchase_history').get();
    for (var purchaseDoc in purchaseSnapshot.docs) {
      revenue += purchaseDoc['totalPrice'];
    }
    setState(() {
      totalRevenue = revenue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            'Total Revenue: RM ${totalRevenue.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 40),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DetailsScreen()),
                              );
                            },
                            child: Text('Monthly and Daily Details'),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MonthlySelectionScreen()),
                              );
                            },
                            child: Text('Customer Time Spent in Store'),
                          ),
                        ],
                      ),
                    ),
                    // Removed the CustomerPresenceLineChart from Dashboard screen as per your requirements
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: constraints.maxWidth > 800 ? 2 : 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: constraints.maxWidth > 800 ? 1.5 : 0.75,
                      children: [
                        GenderDistributionWidget(),
                        AgeDistributionWidget(),
                        TopItemsWidget(),
                        TopCategoriesWidget(),
                      ],
                    ),
                    SizedBox(height: 20),
                    // The chart has been moved to a separate screen accessible via a button
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MonthlySelectionScreen extends StatelessWidget {
  const MonthlySelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Month'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          String month = _monthName(index + 1);
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DailySelectionScreen(month: month),
                ),
              );
            },
            child: Text(month),
          );
        },
      ),
    );
  }

  String _monthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "";
    }
  }
}

class DailySelectionScreen extends StatelessWidget {
  final String month;
  const DailySelectionScreen({Key? key, required this.month}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int daysInMonth = _daysInMonth(month);
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Day in $month'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: daysInMonth,
        itemBuilder: (context, index) {
          String day = (index + 1).toString().padLeft(2, '0');
          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomerTimeSpentScreen(month: month, day: day),
                ),
              );
            },
            child: Text('Day $day'),
          );
        },
      ),
    );
  }

  int _daysInMonth(String month) {
    switch (month) {
      case "February":
        return 28; // Ignoring leap years for simplicity
      case "April":
      case "June":
      case "September":
      case "November":
        return 30;
      default:
        return 31;
    }
  }
}

class CustomerTimeSpentScreen extends StatelessWidget {
  final String month;
  final String day;
  const CustomerTimeSpentScreen({Key? key, required this.month, required this.day}) : super(key: key);

  Future<Map<String, int>> fetchTimeSpentData() async {
    int year = DateTime.now().year;
    DateTime startOfDay = DateTime(year, _monthNumber(month), int.parse(day), 0, 0, 0);
    DateTime endOfDay = DateTime(year, _monthNumber(month), int.parse(day), 23, 59, 59);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('time_spent_in_store')
        .where('in_time', isGreaterThanOrEqualTo: startOfDay)
        .where('in_time', isLessThanOrEqualTo: endOfDay)
        .get();

    Map<String, int> customerCount = {
      "08:00": 0, "09:00": 0, "10:00": 0, "11:00": 0, "12:00": 0, "13:00": 0,
      "14:00": 0, "15:00": 0, "16:00": 0, "17:00": 0, "18:00": 0, "19:00": 0,
      "20:00": 0, "21:00": 0, "22:00": 0, "23:00": 0
    };

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      DateTime inTime = (data['in_time'] as Timestamp).toDate();
      DateTime outTime = (data['out_time'] as Timestamp).toDate();

      for (int i = 8; i <= 23; i++) {
        DateTime currentHourStart = DateTime(year, _monthNumber(month), int.parse(day), i);
        DateTime currentHourEnd = currentHourStart.add(Duration(hours: 1));

        if (inTime.isBefore(currentHourEnd) && outTime.isAfter(currentHourStart)) {
          String hourLabel = "${i.toString().padLeft(2, '0')}:00";
          customerCount[hourLabel] = customerCount[hourLabel]! + 1;
        }
      }
    }

    return customerCount;
  }

  int _monthNumber(String month) {
    switch (month) {
      case "January":
        return 1;
      case "February":
        return 2;
      case "March":
        return 3;
      case "April":
        return 4;
      case "May":
        return 5;
      case "June":
        return 6;
      case "July":
        return 7;
      case "August":
        return 8;
      case "September":
        return 9;
      case "October":
        return 10;
      case "November":
        return 11;
      case "December":
        return 12;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Time Spent on $day $month'),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: fetchTimeSpentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final customerPresenceData = snapshot.data!;
          return CustomerPresenceLineChart(data: customerPresenceData);
        },
      ),
    );
  }
}

class CustomerPresenceLineChart extends StatelessWidget {
  final Map<String, int> data;

  CustomerPresenceLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> spots = [];
    List<String> labels = data.keys.toList();

    for (int i = 0; i < labels.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[labels[i]]!.toDouble()));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  return index >= 0 && index < labels.length ? Text(labels[index]) : Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString());
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: labels.length - 1.toDouble(),
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
