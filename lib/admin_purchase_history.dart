import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPurchaseHistoryPage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    print('Admin user UID: ${user?.uid}');
    print('Admin user displayName: ${user?.displayName}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase History (Admin)'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('purchase_history')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No purchase history available.'),
            );
          }

          var purchaseHistory = snapshot.data!.docs;

          return ListView.builder(
            itemCount: purchaseHistory.length,
            itemBuilder: (context, index) {
              var purchase = purchaseHistory[index];
              var items = List<Map<String, dynamic>>.from(purchase['items']);
              double totalPrice = purchase['totalPrice'];

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Purchase on ${purchase['timestamp'].toDate()}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: items
                        .asMap()
                        .entries
                        .map((entry) => Text('${entry.key + 1}) ${entry.value['title']} -  ${entry.value['price']} x ${entry.value['quantity']}'))
                        .toList(),
                  ),
                  trailing: Text('Total:  ${totalPrice.toStringAsFixed(2)}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
