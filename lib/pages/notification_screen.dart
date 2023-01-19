import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String token = "";
  final StreamController<String?> selectNotificationStream =
  StreamController<String?>.broadcast();
  static  String navigationActionId = 'id_3';
  void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
    print('rought');
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Urgent', 'Urgent',
      importance: Importance.max, priority: Priority.max);

  final DarwinInitializationSettings initializationSettingsDarwin =
  const DarwinInitializationSettings();

  var initializationSettingsAndroid =
  const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = const DarwinInitializationSettings();
  @override
  void initState() {
    super.initState();
    getToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null || android != null) {
        generateLocalNotification(message);


      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
  }


  Future _showNotification(notification) async {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            color: Colors.red,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
        ));
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

  generateLocalNotification(RemoteMessage notificationData) {
    bool isNewNotificationId = false;
    try {
      if (navigationActionId != notificationData.messageId) {
        navigationActionId = notificationData.messageId!;
        isNewNotificationId = true;
      }
    } catch (e) {
      isNewNotificationId = true;
      print(e);
    }
    if(isNewNotificationId) {
      Map<String, dynamic> notificationResponse = notificationPars(notificationData);
      if (notificationResponse != null && notificationResponse.isNotEmpty) {
        try {
          var initializationSettings = InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);
          flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
            onDidReceiveNotificationResponse(notificationResponse);
            // switch (notificationResponse.notificationResponseType) {
            //   case NotificationResponseType.selectedNotification:
            //     selectNotificationStream.add(notificationResponse.payload);
            //     break;
            //   case NotificationResponseType.selectedNotificationAction:
            //     if (notificationResponse.actionId == navigationActionId) {
            //       selectNotificationStream.add(notificationResponse.payload);
            //     }
            //     break;
            // }

          } );
        } catch (e) {
          print(e);
        }
      }
    }
  }


  void showNotification() {
    setState(() {
      _counter++;
    });
    flutterLocalNotificationsPlugin.show(
        0,
        "Testing $_counter",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.red,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }

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