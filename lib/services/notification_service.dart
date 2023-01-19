import 'dart:async';

import 'package:fcm_notifications_test/pages/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title// description
//     importance: Importance.high,
//     playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'iOS Notification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({ Key? key,  required this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future initNotification() async {
  var initializationSettingsAndroid =
  const AndroidInitializationSettings("@drawable/kin_remove");
  var initializationSettingsIOS = DarwinInitializationSettings(
      onDidReceiveLocalNotification:
          (int? id, String? title, String? body, String? payload) async {
        print('payload');
      });

  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  final didNotificationLaunchApp =
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  if (didNotificationLaunchApp) {
    var payload = notificationAppLaunchDetails!;
    onSelectNotification(payload.notificationResponse!);
  } else {
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:onSelectNotification,
        onDidReceiveBackgroundNotificationResponse: onSelectNotification);
  }
}

onSelectNotification(NotificationResponse notificationResponse) async {
  debugPrint('Test');
  // Navigator.of(navigatorKey.currentContext!).push(
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             SecondScreen()));
}
class _MyHomePageState extends State<MyHomePage> {
  String token = "";
  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then(
            (token) {
          setState(() {
            token = token;
            print(token);
          });

        }
    );
  }

  Map<String,dynamic> notificationPars(RemoteMessage notificationData){
    Map<String,dynamic> notificationResponse = {'title':'','body':''};
    if (notificationData.data != null && notificationData.data.length > 0) {
      String title = "";
      String body = "";
      // if (Platform.isAndroid) {
      try {
        RemoteNotification? notificationMap = notificationData.notification;
        title = notificationMap!.title!;
        body = notificationMap.body!;
      } catch (e) {
        print(e);
      }
      Map<String, dynamic> notificationDataTemp = {};
      if (notificationData.data != null) {
        notificationDataTemp = notificationData.data; // Just get string data from notification data key for parsing
      }
      notificationResponse = {'title':'$title','body':'$body','data':notificationDataTemp};
    }
    return notificationResponse;
  }

  // generateLocalNotification(RemoteMessage notificationData) {
  //   bool isNewNotificationId = false;
  //   try {
  //     if (navigationActionId != notificationData.messageId) {
  //       navigationActionId = notificationData.messageId!;
  //       isNewNotificationId = true;
  //     }
  //   } catch (e) {
  //     isNewNotificationId = true;
  //     print(e);
  //   }
  //   if(isNewNotificationId) {
  //     Map<String, dynamic> notificationResponse = notificationPars(notificationData);
  //     if (notificationResponse != null && notificationResponse.isNotEmpty) {
  //       try {
  //         var initializationSettings = InitializationSettings(
  //             android: initializationSettingsAndroid,
  //             iOS: initializationSettingsIOS);
  //         flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
  //           onDidReceiveNotificationResponse(notificationResponse);
  //           // switch (notificationResponse.notificationResponseType) {
  //           //   case NotificationResponseType.selectedNotification:
  //           //     selectNotificationStream.add(notificationResponse.payload);
  //           //     break;
  //           //   case NotificationResponseType.selectedNotificationAction:
  //           //     if (notificationResponse.actionId == navigationActionId) {
  //           //       selectNotificationStream.add(notificationResponse.payload);
  //           //     }
  //           //     break;
  //           // }
  //
  //         } );
  //       } catch (e) {
  //         print(e);
  //       }
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
          child: Text('iOS Notification')
      ),
    );
  }

  redirectToScreen(NotificationResponse notificationResponse) {
    print('redirect to screen');
  }
}