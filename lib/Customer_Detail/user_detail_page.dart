import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                Text('Username: ${userData['username']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Age: ${userData['age']}'),
                Text('Birthday: ${userData['birthday']}'),
                Text('Gender: ${userData['gender']}'),
                Text('Occupation: ${userData['occupation']}'),
                Text('Email: ${userData['email']}'),
                SizedBox(height: 16),
                Text('Reviews:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                          return ListTile(
                            title: Text(reviewData['content']),
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
