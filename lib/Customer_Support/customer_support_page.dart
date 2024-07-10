import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerSupportPage extends StatefulWidget {
  @override
  _CustomerSupportPageState createState() => _CustomerSupportPageState();
}

class _CustomerSupportPageState extends State<CustomerSupportPage> {
  String? selectedRequestId;
  final TextEditingController _messageController = TextEditingController();

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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('help_requests').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
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
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('help_requests')
                              .doc(selectedRequestId)
                              .collection('messages')
                              .orderBy('timestamp', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            }
                            var messages = snapshot.data!.docs;
                            return ListView.builder(
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                var message = messages[index];
                                return ListTile(
                                  title: Text(message['text']),
                                  subtitle: Text(message['sender']),
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
                                  await FirebaseFirestore.instance
                                      .collection('help_requests')
                                      .doc(selectedRequestId)
                                      .collection('messages')
                                      .add({
                                    'sender': 'admin',
                                    'text': _messageController.text,
                                    'timestamp': Timestamp.now(),
                                  });
                                  _messageController.clear();
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
