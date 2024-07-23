import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'revenue.dart'; // Import the RevenueScreen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double totalRevenue = 0.0;
  Map<String, int> genderDistribution = {'Male': 0, 'Female': 0};
  Map<String, int> ageDistribution = {};
  List<Map<String, dynamic>> topItems = [];

  @override
  void initState() {
    super.initState();
    fetchRevenue();
    fetchGenderDistribution();
    fetchAgeDistribution();
    fetchTopItems();
  }

  Future<void> fetchRevenue() async {
    double revenue = 0.0;
    QuerySnapshot purchaseSnapshot = await FirebaseFirestore.instance.collection('purchase_history').get();
    print('Fetched ${purchaseSnapshot.docs.length} purchase histories');
    
    for (var purchaseDoc in purchaseSnapshot.docs) {
      print('Purchase document data: ${purchaseDoc.data()}');
      revenue += purchaseDoc['totalPrice'];
    }
    
    setState(() {
      totalRevenue = revenue;
    });
    print('Total Revenue: $totalRevenue');
  }

  Future<void> fetchGenderDistribution() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    int maleCount = 0;
    int femaleCount = 0;
    for (var doc in querySnapshot.docs) {
      if (doc['gender'] == 'Male') maleCount++;
      if (doc['gender'] == 'Female') femaleCount++;
    }
    setState(() {
      genderDistribution['Male'] = maleCount;
      genderDistribution['Female'] = femaleCount;
    });
  }

  Future<void> fetchAgeDistribution() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
    Map<String, int> ageDist = {};
    for (var doc in querySnapshot.docs) {
      final String? ageStr = doc['age']?.toString();
      if (ageStr != null) {
        if (ageDist.containsKey(ageStr)) {
          ageDist[ageStr] = ageDist[ageStr]! + 1;
        } else {
          ageDist[ageStr] = 1;
        }
      }
    }
    setState(() {
      ageDistribution = ageDist;
    });
  }

  Future<void> fetchTopItems() async {
    Map<String, int> itemQuantities = {};
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('purchase_history').get();
    for (var purchaseDoc in querySnapshot.docs) {
      List<dynamic> items = purchaseDoc['items'];
      for (var item in items) {
        String itemName = item['title'];
        int quantity = int.parse(item['quantity'] ?? '1');  // Ensure quantity is an integer
        itemQuantities[itemName] = (itemQuantities[itemName] ?? 0) + quantity;
      }
    }
    List<Map<String, dynamic>> sortedItems = itemQuantities.entries
        .map((entry) => {'name': entry.key, 'quantity': entry.value})
        .toList()
      ..sort((a, b) => (b['quantity'] as int).compareTo(a['quantity'] as int));
    setState(() {
      topItems = sortedItems.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              Navigator.pushNamed(context, '/revenue'); // Navigate to the RevenueScreen
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Total Revenue: RM ${totalRevenue.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 20),
            const Text('Gender Distribution'),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _createGenderData(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Age Distribution'),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: _createAgeData(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Top 5 Hot Items'),
            ...topItems.map((item) => ListTile(
              title: Text(item['name']),
              subtitle: Text('Quantity: ${item['quantity']}'),
            )),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _createGenderData() {
    return genderDistribution.entries.map((entry) {
      final isMale = entry.key == 'Male';
      return PieChartSectionData(
        color: isMale ? Colors.blue : Colors.pink,
        value: entry.value.toDouble(),
        title: '${entry.key}: ${entry.value}',
      );
    }).toList();
  }

  List<BarChartGroupData> _createAgeData() {
    return ageDistribution.entries.map((entry) {
      return BarChartGroupData(
        x: int.parse(entry.key),
        barRods: [
          BarChartRodData(toY: entry.value.toDouble(), color: Colors.lightBlueAccent)
        ],
      );
    }).toList()
    ..sort((a, b) => a.x.compareTo(b.x));
  }
}
