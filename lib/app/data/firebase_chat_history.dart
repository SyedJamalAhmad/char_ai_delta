import 'dart:math';
import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseChatHistory {
  final String characterName;
  final List<FirebaseChat> chatList;

  FirebaseChatHistory({
    required this.characterName,
    required this.chatList,
  });

  // Create a Character from a Firestore document snapshot
  factory FirebaseChatHistory.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data()!;
    return FirebaseChatHistory(
      characterName: data['characterName'],
      chatList: (data['chatList'] as List<dynamic>)
          .map((chat) => FirebaseChat.fromMap(chat))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'characterName': characterName,
      'chatList': chatList.map((chat) => chat.toMap()).toList(),
    };
  }

  factory FirebaseChatHistory.fromMap(Map<String, dynamic> map) {
    developer.log("FirebaseChatHistory List: $map");

    return FirebaseChatHistory(
      characterName: map['characterName'] as String,
      chatList: (map['chatList'] as List<dynamic>)
          .map((chat) => FirebaseChat.fromMap(chat))
          .toList(),
    );
  }
}

class FirebaseChat {
  final Timestamp timestamp;
  final String message;
  final String senderType;

  FirebaseChat({
    required this.timestamp,
    required this.message,
    required this.senderType,
  });

  // Create a FirebaseChat from a map
  factory FirebaseChat.fromMap(Map<String, dynamic> map) {
    developer.log("Chat List: $map");
    return FirebaseChat(
      timestamp: map['timestamp'],
      message: map['message'],
      senderType: map['senderType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'message': message,
      'senderType': senderType,
    };
  }
}
