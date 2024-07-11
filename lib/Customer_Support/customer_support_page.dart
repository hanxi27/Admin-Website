import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CustomerSupportPage(),
    );
  }
}

class CustomerSupportPage extends StatefulWidget {
  @override
  _CustomerSupportPageState createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  String? selectedRequestId;
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String adminEmail = 'admin@example.com'; // Replace with your admin email

  Future<void> _signInAdmin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: adminEmail, // Replace with admin email
        password: 'adminPassword', // Replace with admin password
      );
      User? user = userCredential.user;
      if (user != null) {
        print('Admin signed in: ${user.email}');
      }
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _signInAdmin(); // Automatically sign in the admin on app start
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Support'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('help_requests').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No help requests found'));
                }
                var helpRequests = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: helpRequests.length,
                  itemBuilder: (context, index) {
                    var request = helpRequests[index];
                    return ListTile(
                      title: Text(request['username']),
                      subtitle: Text(request['message']),
                      onTap: () {
                        setState(() {
                          selectedRequestId = request.id;
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: selectedRequestId == null
                ? Center(child: Text('Select a request to view messages'))
                : Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('help_requests')
                              .doc(selectedRequestId)
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No messages found'));
                            }
                            var messages = snapshot.data!.docs;
                            return ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                var message = messages[index];
                                String sender = message['sender'] == adminEmail ? 'admin' : message['sender'];
                                return ListTile(
                                  title: Text(message['text']),
                                  subtitle: Text(sender),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Type a message',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () async {
                                if (_messageController.text.isNotEmpty) {
                                  try {
                                    User? user = _auth.currentUser;
                                    if (user != null) {
                                      await FirebaseFirestore.instance
                                          .collection('help_requests')
                                          .doc(selectedRequestId)
                                          .collection('messages')
                                          .add({
                                        'sender': user.email == adminEmail ? 'admin' : user.email,
                                        'text': _messageController.text,
                                        'timestamp': Timestamp.now(),
                                      });
                                      _messageController.clear();
                                    } else {
                                      print('Admin is not authenticated');
                                    }
                                  } catch (e) {
                                    print('Failed to send message: $e');
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
