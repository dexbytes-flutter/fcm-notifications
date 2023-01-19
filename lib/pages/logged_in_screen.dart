import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_test/pages/sign_in_screen.dart';

import '../bloC/sign/google_signIn_cubit.dart';
import '../bloC/sign/google_sign_in_state.dart';
import 'chat_screen.dart';

class LoggedInScreen extends StatefulWidget {
  const LoggedInScreen({Key? key}) : super(key: key);

  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;


    return Scaffold(
      // backgroundColor: const Color(0xFF141D3B),
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("Logged In",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: Color(0xFf2AAE96)),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
                child: Image.network(user!.photoURL!)),
            const  SizedBox(height: 10,),
            Text(user.displayName!,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xFf2AAE96)),),
            const  SizedBox(height: 10,),
            Text(user.email!,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Color(0xFf2AAE96)),),
            const  SizedBox(height: 10,),
            TextButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
            },
                style: const ButtonStyle(
                    side: MaterialStatePropertyAll(BorderSide(width: 0.7,color: Colors.grey)),
                    backgroundColor: MaterialStatePropertyAll(Color(0xFf2AAE96))),
                child: Text("Go To Chat", style: TextStyle(color: Colors.white),)),

            BlocListener<GoogleSignInCubit, GoogleSingInState>(
              listener: (context, state) {
                if (state is GoogleSignInErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.red,
                      content: Text(state.signInErrorMessage),
                    ),
                  );
                } else if (state is GoogleSignOutSuccessState) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                }
              },
              child: TextButton(onPressed: (){
                BlocProvider.of<GoogleSignInCubit>(context).logout();
              },
                  style: const ButtonStyle(
                      side: MaterialStatePropertyAll(BorderSide(width: 0.7,color: Colors.grey)),
                      backgroundColor: MaterialStatePropertyAll(Color(0xFf2AAE96))),
                  child: Text("Log Out", style: TextStyle(color: Colors.white),))
            ),


          ],
        ),
      ),
    );
  }
}
