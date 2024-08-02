import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;
import 'package:my_new_project/Map/map_page.dart'; // Import the MapPage

class CustomerSupportPage extends StatefulWidget {
  @override
  _CustomerSupportPageState createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  String? selectedRequestId;
  String? selectedUsername;
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, bool> unreadMessages = {}; // Changed to boolean to indicate if there are any unread messages
  Set<String> displayedMessages = {};

  Future<void> _signInAdmin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: 'admin@example.com', // Replace with admin email
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
    _listenForMessages();
  }

  void _listenForMessages() {
    FirebaseFirestore.instance.collection('help_requests').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        String requestId = doc.id;
        FirebaseFirestore.instance
            .collection('help_requests')
            .doc(requestId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((messageSnapshot) {
          bool hasUnread = messageSnapshot.docs.any((message) => message['sender'] != 'Admin' && !displayedMessages.contains(message.id));
          setState(() {
            unreadMessages[requestId] = hasUnread;
          });

          if (hasUnread && !displayedMessages.contains(messageSnapshot.docs.first.id)) {
            displayedMessages.add(messageSnapshot.docs.first.id);
            _showNotification("New message", doc['username']);
          }
        });
      }
    });
  }

  void _navigateToMap(BuildContext context, String coordinates) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MapPage(
          coordinates: coordinates,
        ),
      ),
    );
  }

  void _showNotification(String message, String sender) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final overlay = Overlay.of(context);
      final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 50.0,
          right: 10.0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                '$sender: $message',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );

      overlay?.insert(overlayEntry);
      Future.delayed(Duration(seconds: 3), () {
        overlayEntry.remove();
      });
    });
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
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Customer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
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
                          bool hasUnread = unreadMessages[request.id] ?? false;
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            title: Text(
                              request['username'],
                              style: TextStyle(
                                fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            trailing: hasUnread
                                ? badges.Badge(
                                    badgeContent: Icon(
                                      Icons.mark_email_unread,
                                      color: Colors.white,
                                      size: 16.0,
                                    ),
                                    badgeStyle: badges.BadgeStyle(
                                      shape: badges.BadgeShape.circle,
                                      badgeColor: Colors.red,
                                      padding: EdgeInsets.all(8),
                                    ),
                                  )
                                : null,
                            onTap: () {
                              setState(() {
                                selectedRequestId = request.id;
                                selectedUsername = request['username'];
                                unreadMessages[request.id] = false; // Clear unread notification
                              });
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            color: Colors.grey,
            width: 1,
          ),
          Expanded(
            flex: 2,
            child: selectedRequestId == null
                ? Center(child: Text('Select a request to view messages'))
                : Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.0),
                        color: Colors.grey[200],
                        width: double.infinity,
                        child: Text(
                          selectedUsername ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
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
                            for (var message in messages) {
                              final data = message.data() as Map<String, dynamic>;
                              if (!displayedMessages.contains(message.id)) {
                                displayedMessages.add(message.id);
                              }
                            }

                            return ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                var message = messages[index];
                                final isAdmin = message['sender'] == 'Admin';
                                final data = message.data() as Map<String, dynamic>;
                                final String coordinates = data.containsKey('redDotCoordinates')
                                    ? '(${data['redDotCoordinates']['x']}, ${data['redDotCoordinates']['y']})'
                                    : '';

                                return Align(
                                  alignment: isAdmin ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isAdmin ? Colors.blue[100] : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(child: Text(message['text'])),
                                        if (!isAdmin && coordinates.isNotEmpty)
                                          IconButton(
                                            icon: Icon(Icons.location_on),
                                            onPressed: () => _navigateToMap(context, coordinates),
                                          ),
                                      ],
                                    ),
                                  ),
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
                                        'sender': 'Admin',
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
