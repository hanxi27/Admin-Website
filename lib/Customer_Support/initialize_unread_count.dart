import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_new_project/firebase_options.dart'; // Ensure this file exists in the lib directory

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Login as admin
  await loginAsAdmin();

  // Ensure the user is authenticated before running the script
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    print('Admin login failed');
    runApp(MyApp());
    return;
  }

  await initializeUnreadCount(); // Ensure this runs before starting the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Initialize unread_count')),
        body: Center(child: Text('Initializing unread_count field...')),
      ),
    );
  }
}

Future<void> loginAsAdmin() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'innoadmin@example.com', // Replace with verified admin email
      password: 'innoadmin@example.com', // Replace with verified admin password
    );
    User? user = userCredential.user;
    if (user != null) {
      print('Admin signed in: ${user.email}');
    }
  } catch (e) {
    print('Failed to sign in: $e');
  }
}

Future<void> initializeUnreadCount() async {
  try {
    final helpRequests = await FirebaseFirestore.instance.collection('help_requests').get();
    print('Total documents: ${helpRequests.docs.length}');
    for (var doc in helpRequests.docs) {
      print('Checking document ID: ${doc.id}');
      if (!doc.data().containsKey('unread_count')) {
        print('Updating document ID: ${doc.id}');
        await doc.reference.update({
          'unread_count': 0,
        });
        print('Document ID: ${doc.id} updated successfully');
      } else {
        print('Document ID: ${doc.id} already has unread_count field');
      }
    }
    print('Initialization complete');
  } catch (e) {
    print('Error during initialization: $e');
  }
}
