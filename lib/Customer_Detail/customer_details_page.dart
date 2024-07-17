import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_new_project/Customer_Detail/user_detail_page.dart'; // Correct import path

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
              bool hasRequiredFields = userData.containsKey('username');

              if (!hasRequiredFields) {
                return ListTile(
                  title: Text('Missing data for user'),
                );
              }

              return ListTile(
                title: Text(
                  userData['username'],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailPage(userId: user.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
