import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting the timestamp

class UserDetailPage extends StatelessWidget {
  final String userId;

  UserDetailPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User not found'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${userData['username'] ?? 'N/A'}',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.cake),
                            SizedBox(width: 8),
                            Text('Age: ${userData['age'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8),
                            Text('Birthday: ${userData['birthday'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 8),
                            Text('Gender: ${userData['gender'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.work),
                            SizedBox(width: 8),
                            Text('Occupation: ${userData['occupation'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.email),
                            SizedBox(width: 8),
                            Text('Email: ${userData['email'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Reviews:', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection('reviews')
                        .snapshots(),
                    builder: (context, reviewSnapshot) {
                      if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (!reviewSnapshot.hasData || reviewSnapshot.data!.docs.isEmpty) {
                        return Text('No reviews');
                      }
                      var reviews = reviewSnapshot.data!.docs;
                      return ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          var reviewData = reviews[index].data() as Map<String, dynamic>;
                          var timestamp = (reviewData['timestamp'] as Timestamp).toDate();
                          var formattedTimestamp = DateFormat('yyyy-MM-dd – kk:mm').format(timestamp);

                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(reviewData['review'] ?? 'No content', style: TextStyle(fontSize: 18)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Rating: ${reviewData['rating'] ?? 'N/A'}', style: TextStyle(fontSize: 16)),
                                  Text('Timestamp: $formattedTimestamp', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
