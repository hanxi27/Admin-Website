import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the charting library

class CustomerTimeSpentScreen extends StatelessWidget {
  final String month;
  final String day;
  const CustomerTimeSpentScreen({Key? key, required this.month, required this.day}) : super(key: key);

  Future<Map<String, int>> fetchTimeSpentData() async {
    // Parse the selected date
    int year = DateTime.now().year;
    int selectedMonth = DateTime.parse("$year-${month.padLeft(2, '0')}-01").month;
    int selectedDay = int.parse(day);

    // Define the start and end of the selected day
    DateTime startOfDay = DateTime(year, selectedMonth, selectedDay, 0, 0, 0);
    DateTime endOfDay = DateTime(year, selectedMonth, selectedDay, 23, 59, 59);

    print("Fetching data for: $startOfDay to $endOfDay");

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('time_spent_in_store')
        .where('in_time', isGreaterThanOrEqualTo: startOfDay)
        .where('in_time', isLessThanOrEqualTo: endOfDay)
        .get();

    // Initialize a map to hold the customer counts for each hour
    Map<String, int> customerCount = {
      "08:00": 0, "09:00": 0, "10:00": 0, "11:00": 0, "12:00": 0, "13:00": 0,
      "14:00": 0, "15:00": 0, "16:00": 0, "17:00": 0, "18:00": 0, "19:00": 0,
      "20:00": 0, "21:00": 0, "22:00": 0, "23:00": 0
    };

    print("Documents found: ${snapshot.docs.length}");

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      DateTime inTime = (data['in_time'] as Timestamp).toDate();
      DateTime outTime = (data['out_time'] as Timestamp).toDate();

      print("Processing: in_time=$inTime, out_time=$outTime");

      // Loop through each hour in the day
      for (int i = 8; i <= 23; i++) {
        DateTime currentHourStart = DateTime(year, selectedMonth, selectedDay, i);
        DateTime currentHourEnd = currentHourStart.add(Duration(hours: 1));

        // If the customer was in the store during this hour, count them
        if (inTime.isBefore(currentHourEnd) && outTime.isAfter(currentHourStart)) {
          String hourLabel = "${i.toString().padLeft(2, '0')}:00";
          customerCount[hourLabel] = customerCount[hourLabel]! + 1;
          print("Incremented count for $hourLabel");
        }
      }
    }

    return customerCount;
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
