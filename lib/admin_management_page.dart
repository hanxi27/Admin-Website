import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class AdminManagementPage extends StatefulWidget {
  @override
  _AdminManagementPageState createState() => _AdminManagementPageState();
}

class _AdminManagementPageState extends State<AdminManagementPage> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> addAdmin(String email) async {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('addAdminRole');
    try {
      final results = await callable.call(<String, dynamic>{
        'email': email,
      });
      print(results.data['message']);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(results.data['message'])));
    } catch (e) {
      print('Error adding admin: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding admin: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_emailController.text.isNotEmpty) {
                  addAdmin(_emailController.text);
                }
              },
              child: Text('Add Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
