import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_test/pages/chat_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloC/sign/google_signIn_cubit.dart';
import '../bloC/sign/google_sign_in_state.dart';
import 'logged_in_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      body: SafeArea(
        child: BlocListener<GoogleSignInCubit, GoogleSingInState>(
          listener: (context, state) {
            if (state is GoogleSignInErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(state.signInErrorMessage),
                ),
              );
            } else if (state is GoogleSignInSuccesslState) {
              Navigator.popUntil(context, (route) => route.isFirst);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoggedInScreen()));
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 60,),
                  Image.asset("assets/images/login_image.jpg",height: MediaQuery.of(context).size.height/2.2,),
                  const SizedBox(height: 15,),
                  const Text("Welcome to Chat App",
                    style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.black),),
                  const SizedBox(height: 15,),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 30),
                     child: Text("Chat with your friend, share photos and videos file fast with high quality",
                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.grey.shade400),textAlign:TextAlign.center,),
                   ),
                  const SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      BlocProvider.of<GoogleSignInCubit>(context).googleSignIn();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          color: const Color(0xFf2AAE96),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          FaIcon(FontAwesomeIcons.google,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Sign In using Google",
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
