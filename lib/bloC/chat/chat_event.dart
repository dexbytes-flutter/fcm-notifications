import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatEvent {}

class MsgTextChangeEvent extends ChatEvent {
  late String msgString;
  MsgTextChangeEvent(this.msgString);
}

class MsgSendEvent extends ChatEvent {
  late String msgString;
  late String sendBy;
  late Timestamp msgDate;
  late String uid;
  MsgSendEvent(this.msgString, this.sendBy,this.msgDate,this.uid);
}

// class LoginTextChangeEvent extends LoginEvent {}

// class LoginTextChangeEvent extends LoginEvent {}