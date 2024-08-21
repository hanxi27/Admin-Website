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
  Map<String, int> customerPresenceData = {};

  @override
  void initState() {
    super.initState();
    fetchRevenue();
    fetchCustomerPresenceData().then((data) {
      setState(() {
        customerPresenceData = data;
      });
    });
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

  Future<Map<String, int>> fetchCustomerPresenceData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('time_spent_in_store').get();

    // Initialize a map to hold the customer counts for each hour
    Map<String, int> customerCount = {
      "08:00": 0, "09:00": 0, "10:00": 0, "11:00": 0, "12:00": 0, "13:00": 0,
      "14:00": 0, "15:00": 0, "16:00": 0, "17:00": 0, "18:00": 0, "19:00": 0,
      "20:00": 0, "21:00": 0, "22:00": 0, "23:00": 0
    };

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      Timestamp inTime = data['in_time'];
      Timestamp outTime = data['out_time'];

      // Calculate customer presence for each hour
      DateTime inDateTime = inTime.toDate();
      DateTime outDateTime = outTime.toDate();

      for (int i = 8; i <= 23; i++) {
        DateTime currentHourStart = DateTime(inDateTime.year, inDateTime.month, inDateTime.day, i);
        DateTime currentHourEnd = currentHourStart.add(Duration(hours: 1));

        if (outDateTime.isAfter(currentHourStart) && inDateTime.isBefore(currentHourEnd)) {
          String hourLabel = "${i.toString().padLeft(2, '0')}:00";
          customerCount[hourLabel] = customerCount[hourLabel]! + 1;
        }
      }
    }

    return customerCount;
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
                        ],
                      ),
                    ),
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
                    customerPresenceData.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              color: Colors.white, // Set the background color to white
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Customer Time Spent in Store',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    height: 300, // Set a fixed height for the chart
                                    child: CustomerPresenceLineChart(data: customerPresenceData),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : CircularProgressIndicator(),
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

    return LineChart(
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
    );
  }
}
