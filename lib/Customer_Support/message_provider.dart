import 'package:flutter/material.dart';

class MessageProvider with ChangeNotifier {
  Map<String, bool> unreadMessages = {}; // Map to track unread messages

  void setRead(String requestId) {
    unreadMessages[requestId] = false;
    notifyListeners();
  }

  void setUnread(String requestId) {
    unreadMessages[requestId] = true;
    notifyListeners();
  }

  bool hasUnread(String requestId) {
    return unreadMessages[requestId] ?? false;
  }
}
