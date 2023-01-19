import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required  this.analytics, required this.observer}) : super(key: key);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> buttonClicked()async {
    widget.analytics.logEvent(
      name: 'button_clicked',
      parameters: <String,dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
      }
    );
  }
  Future<void> setScreen()async {
    widget.analytics.setCurrentScreen(
       screenName: 'home_screen',
      screenClassOverride: 'flutter',
    );
  }

  @override
   initState()  {
    // TODO: implement initState
    setScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Firebase Events'),),
    body: Center(child: OutlinedButton(onPressed: () => buttonClicked(),child: const Text('Log event'),),),
    );
  }
}
