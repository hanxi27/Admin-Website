import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerTimeSpentScreen extends StatelessWidget {
  const CustomerTimeSpentScreen({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchTimeSpentData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('time_spent_in_store').get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Time Spent in Store'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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

          final timeSpentData = snapshot.data!;
          return ListView.builder(
            itemCount: timeSpentData.length,
            itemBuilder: (context, index) {
              final data = timeSpentData[index];
              return ListTile(
                title: Text('Username: ${data['username']}'),
                subtitle: Text('Time Spent: ${data['time_spent_minutes']} minutes'),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('In Time: ${data['in_time']}'),
                    Text('Out Time: ${data['out_time']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
