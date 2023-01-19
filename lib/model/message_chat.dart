import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebaase_constants.dart';

class MessageChat {
  String msgString;
  Timestamp msgDate;
  String sendBy;
  String uid;

  MessageChat({
    required this.msgString,
    required this.msgDate,
    required this.sendBy,
    required this.uid
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.msgString: this.msgString,
      FirestoreConstants.msgDate: this.msgDate,
      FirestoreConstants.sendBy: this.sendBy,
      FirestoreConstants.uid: this.uid,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String msgString = doc.get(FirestoreConstants.msgString);
    Timestamp msgDate = doc.get(FirestoreConstants.msgDate);
    String sendBy = doc.get(FirestoreConstants.sendBy);
    String uid = doc.get(FirestoreConstants.uid);
    return MessageChat(msgString: msgString, msgDate: msgDate, sendBy: sendBy,uid: uid);
  }
}
