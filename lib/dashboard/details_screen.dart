import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'daily_revenue.dart';  // Import DailyRevenueChart
import 'monthly_revenue.dart';  // Import MonthlyRevenueChart
import 'visit.dart';  // Import VisitChart

class DetailsScreen extends StatefulWidget {
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double totalRevenue = 0.0;
  Map<DateTime, double> dailyRevenue = {};
  Map<String, double> monthlyRevenue = {};
  Map<DateTime, int> dailyVisits = {};  // Map to store daily visit data
  double selectedValue = 0.0;
  String selectedYear = '2024';
  String selectedMonth = '08';

  @override
  void initState() {
    super.initState();
    fetchRevenue();
    fetchDailyVisits();  // Fetch daily visits data
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

  Future<void> fetchDailyVisits() async {
    Map<DateTime, int> visits = {};
    QuerySnapshot purchaseSnapshot = await FirebaseFirestore.instance.collection('purchase_history').get();

    for (var purchaseDoc in purchaseSnapshot.docs) {
      Timestamp timestamp = purchaseDoc['timestamp'];
      DateTime purchaseDate = timestamp.toDate();

      // Daily visits
      DateTime day = DateTime(purchaseDate.year, purchaseDate.month, purchaseDate.day);
      visits[day] = (visits[day] ?? 0) + 1;  // Increment the visit count for each day
    }

    setState(() {
      dailyVisits = visits;
    });
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
              Text(
                'Total Revenue: RM ${totalRevenue.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                'Selected Revenue: RM ${selectedValue.toStringAsFixed(2)}',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
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
                    child: Text('2024'),
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
              Row(
                children: [
                  Expanded(
                    child: DailyRevenueChart(
                      dailyRevenue: dailyRevenue,
                      selectedYear: selectedYear,
                      selectedMonth: selectedMonth,
                      onBarTouch: (value) {
                        setState(() {
                          selectedValue = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16), // Add space between the charts
                  Expanded(
                    child: VisitChart(
                      dailyVisits: dailyVisits,
                      selectedYear: selectedYear,
                      selectedMonth: selectedMonth,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),  // Space between top charts and bottom chart
              Container(
                width: double.infinity,
                child: MonthlyRevenueChart(
                  monthlyRevenue: monthlyRevenue,
                  selectedYear: selectedYear,
                  onBarTouch: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
