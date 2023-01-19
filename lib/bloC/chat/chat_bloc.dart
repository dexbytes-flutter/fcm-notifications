import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_test/bloC/chat/chat_state.dart';

import '../../firebaase_constants.dart';
import 'chat_event.dart';


class ChatBloc extends Bloc<ChatEvent, ChatState> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  ChatBloc() : super(ChatInitialState()) {
    // on<MsgTextChangeEvent>((event, emit) {
    //   if (event.msgString == '' || event.msgString.isEmpty) {
    //     emit(LoginFormErrorState('Enter email address'));
    //   } else if (event.loginPasswordValue == '' ||
    //       event.loginPasswordValue.isEmpty) {
    //     emit(LoginFormErrorState('Enter password'));
    //   } else {
    //     emit(LoginFormValidState());
    //   }
    // });

    on<MsgSendEvent>((event, emit) async {
      emit(ChatLoadingState());
      try {
        // final UserCredential user = await _auth.signInWithEmailAndPassword(
        //     email: event.loginEmail, password: event.loginPassword);
        Map<String, dynamic> msgData = {'msgDate' : Timestamp.now(),'msgString' : event.msgString,'sendBy' : event.sendBy,'uid': event.uid};
        await fireStore
            .collection('users_chat').add(msgData);

        // if (user.user != null) {
        //   emit(LoginSuccessState('Login Successfully'));
        // }
      } on FirebaseAuthException catch (e) {
        emit(ChatErrorState(e.message.toString()));
      }
    });

  }
  Stream<QuerySnapshot> getChatStream() {
    return fireStore
        .collection('users_chat')
    .orderBy(FirestoreConstants.msgDate, descending: true)
    // .limit(limit)
        .snapshots();
  }
}