import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details Page'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];

              // Check if user data is not null
              var userData = user.data() as Map<String, dynamic>?;

              if (userData == null) {
                return ListTile(
                  title: Text('Missing data for user'),
                );
              }

              // Check if all required fields exist in the document
              bool hasRequiredFields = userData.containsKey('username') &&
                  userData.containsKey('age') &&
                  userData.containsKey('birthday') &&
                  userData.containsKey('gender') &&
                  userData.containsKey('occupation') &&
                  userData.containsKey('email');

              if (!hasRequiredFields) {
                return ListTile(
                  title: Text('Missing data for user'),
                );
              }

              return ListTile(
                title: Text('Username: ${userData['username']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Age: ${userData['age']}'),
                    Text('Birthday: ${userData['birthday']}'),
                    Text('Gender: ${userData['gender']}'),
                    Text('Occupation: ${userData['occupation']}'),
                    Text('Email: ${userData['email']}'),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.id)
                          .collection('reviews')
                          .snapshots(),
                      builder: (context, reviewSnapshot) {
                        if (reviewSnapshot.connectionState == ConnectionState.waiting) {
                          return Text('Loading reviews...');
                        }
                        if (!reviewSnapshot.hasData || reviewSnapshot.data!.docs.isEmpty) {
                          return Text('No reviews');
                        }
                        var reviews = reviewSnapshot.data!.docs;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: reviews.map((review) {
                            var reviewData = review.data() as Map<String, dynamic>;
                            return Text('Review: ${reviewData['content']}');
                          }).toList(),
                        );
                      },
                    ),
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
