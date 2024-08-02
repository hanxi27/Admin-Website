import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class GenderDistributionWidget extends StatefulWidget {
  @override
  _GenderDistributionWidgetState createState() => _GenderDistributionWidgetState();
}

class _GenderDistributionWidgetState extends State<GenderDistributionWidget> {
  Map<String, int> genderDistribution = {'Male': 0, 'Female': 0};

  @override
  void initState() {
    super.initState();
    fetchGenderDistribution();
  }

  Future<void> fetchGenderDistribution() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    int maleCount = 0;
    int femaleCount = 0;
    for (var doc in querySnapshot.docs) {
      String gender = doc['gender'].toString().toLowerCase();
      if (gender == 'male') maleCount++;
      if (gender == 'female') femaleCount++;
    }
    setState(() {
      genderDistribution['Male'] = maleCount;
      genderDistribution['Female'] = femaleCount;
    });
  }

  List<PieChartSectionData> _createGenderData() {
    return genderDistribution.entries.map((entry) {
      final isMale = entry.key == 'Male';
      return PieChartSectionData(
        color: isMale ? Colors.blue : Colors.pink,
        value: entry.value.toDouble(),
        title: '${entry.key}: ${entry.value}',
        radius: 150,
      );
    }).toList();
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
        children: [
          const Text('Gender Distribution'),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: _createGenderData(),
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
