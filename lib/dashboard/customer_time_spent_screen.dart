import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the charting library

class CustomerTimeSpentScreen extends StatelessWidget {
  const CustomerTimeSpentScreen({Key? key}) : super(key: key);

  Future<Map<String, int>> fetchTimeSpentData() async {
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
      appBar: AppBar(
        title: Text('Customer Time Spent in Store'),
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
