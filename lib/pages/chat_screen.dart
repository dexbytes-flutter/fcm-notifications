import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_test/bloC/chat/chat_bloc.dart';
import 'package:flutter_firebase_test/bloC/chat/chat_event.dart';
import 'package:flutter_firebase_test/bloC/chat/chat_state.dart';
import 'package:intl/intl.dart';

import '../bloC/sign/google_signIn_cubit.dart';
import '../model/message_chat.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}


class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    List<QueryDocumentSnapshot> listMessage = [];
    final _formKey = GlobalKey<FormState>();
    TextEditingController _msgValue = TextEditingController();
    final UserCredential userCredential = BlocProvider.of<GoogleSignInCubit>(context).userCredential;
    final ChatBloc chatBloc = BlocProvider.of<ChatBloc>(context);

   Widget buildItem(int index, DocumentSnapshot? document){
      if(document != null){
        MessageChat messageChat = MessageChat.fromDocument(document);
        var msgDt = DateTime.fromMicrosecondsSinceEpoch(messageChat.msgDate.microsecondsSinceEpoch);
        bool isThisUser =  messageChat.uid == userCredential.user?.uid;
        return  Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: isThisUser?MainAxisAlignment.end:MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: isThisUser ? Color(0xFf2AAE96): Colors.yellow.shade100,
                ),
                padding: const EdgeInsets.all(10).copyWith(left: 15),
                margin: isThisUser ? const EdgeInsets.only(bottom: 8,left: 60) : const EdgeInsets.only(bottom: 8,right: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: isThisUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(messageChat.msgString,style: const TextStyle(fontSize: 16,color: Colors.white),),
                  const SizedBox(height: 5,),
                  Text(messageChat.sendBy,style: const TextStyle(fontSize: 7,color: Colors.white),),
                  const SizedBox(height: 1.5,),
                  Text(DateFormat("hh:mm").format(msgDt),style: const TextStyle(fontSize: 7,color: Colors.white),)
                ],
              ),),
            ),
          ],
        );
      }else{
        return const SizedBox();
      }
    }

    // Chat List
    Widget buildListMessage() {
      return Flexible(
        child: StreamBuilder<QuerySnapshot>(
          stream: chatBloc.getChatStream(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              listMessage = snapshot.data!.docs;
              if (listMessage.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) => buildItem(index, snapshot.data?.docs[index]),
                  itemCount: snapshot.data?.docs.length,
                  reverse: true,
                  // controller: listScrollController,
                );
              } else {
                return const Center(child: Text("No message here yet..."));
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      },icon: Icon(CupertinoIcons.back, color: Color(0xFf2AAE96),),),
      title: const Text('Chat Board', style: TextStyle(color: Color(0xFf2AAE96)),),),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<ChatBloc,ChatState>(
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildListMessage(),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                      // First child is enter comment text input
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                  return '';
                              }
                                  return null;
                              },
                            controller: _msgValue,
                            autocorrect: false,
                            decoration:  InputDecoration(
                              hintText: "Enter message......",
                              fillColor: Colors.grey.shade50,
                              filled: true,
                              focusColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.only(left: 15,right: 15,top: 5,bottom: 5),
                              border: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(35),
                                  borderSide:BorderSide(color: Colors.grey.shade50,width: 0.5)),
                            ),
                          ),
                        ),
                      ),
                      // Second child is button
                      IconButton(
                        icon: const Icon(Icons.send,color: Color(0xFf2AAE96),),
                        iconSize: 30.0,
                        onPressed: () async {
                         if(_msgValue == null || _msgValue.text.isEmpty){
                           return null;
                         }
                          if(_formKey.currentState!.validate()){
                            BlocProvider.of<ChatBloc>(context).add(MsgSendEvent(_msgValue.text, userCredential.user!.providerData.first.displayName!, Timestamp.now(),userCredential.user!.uid));
                            _formKey.currentState?.reset();
                          }
                        },
                      )
                    ])),
              ],
            );
          }
        ),
      ),
    );
  }
}
