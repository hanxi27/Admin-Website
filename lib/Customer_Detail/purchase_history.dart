import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // Add this for date formatting

class PurchaseHistory extends StatelessWidget {
  final String userId;

  const PurchaseHistory({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('purchase_history')
          .where('userId', isEqualTo: userId)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No purchase history available.'));
        }

        var purchaseHistory = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: purchaseHistory.length,
          itemBuilder: (context, index) {
            var purchase = purchaseHistory[index];
            var items = List<Map<String, dynamic>>.from(purchase['items']);
            double totalPrice = purchase['totalPrice'];

            // Format the timestamp to only display hour, minute, and second
            var timestamp = purchase['timestamp'].toDate();
            var formattedTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);

            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('Purchase on $formattedTimestamp'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: items
                      .asMap()
                      .entries
                      .map((entry) {
                        var item = entry.value;
                        var title = item['title'] ?? 'N/A';
                        var price = item['price'] ?? 'N/A';
                        var quantity = item['quantity'] ?? 0;

                        return Text('${entry.key + 1}) $title - $price x $quantity');
                      })
                      .toList(),
                ),
                trailing: Text('Total: ${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            );
          },
        );
      },
    );
  }
}
