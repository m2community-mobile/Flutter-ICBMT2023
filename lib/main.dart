import 'dart:developer';
import 'dart:io';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';


import 'controller/notification_controller.dart';

import 'page/booth_intro.dart';
import 'page/booth_scane.dart';
import 'page/glance_view.dart';
import 'page/home.dart';
import 'page/intro.dart';
import 'page/photo_view.dart';
import 'page/voting.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /**
   * 확인 
   * 안드로이드 
   * 수신 : background / terminated
   */
  log('_firebaseMessagingBackgroundHandler');
  debugPrint('_firebaseMessagingBackgroundHandler');
  await Firebase.initializeApp();
  await setupFlutterNotifications();
}

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {

  /**
   * 확인 
   * 안드로이드 - alarm
   * 클릭 - foreground : O / background : O / terminated : X
   * 안드로이드 - push
   * 클릭 - foreground : X / background : X / terminated : X
   * 
   * IOS - alarm
   * 클릭 - foreground : O / background : O / terminated : ?
   * IOS - push
   * 클릭 - foreground : X / background : X / terminated : ?
   */

  
  log('noti : onDidReceiveNotificationResponse');
  debugPrint('noti : onDidReceiveNotificationResponse');

  String response = notificationResponse.payload ?? '';
  log("payload $response");
  debugPrint("payload $response");

  Map<String, dynamic> data = jsonDecode(response);

  log("data ${data.toString()}");
  NotificationController(type: data['type'], sid: data['sid'], title: data['title'],  content: data['content'], tab: data['tab']).showDialog();

}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );


  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  var initialzationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initialzationSettingsIOS =  const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
    // notificationCategories: darwinNotificationCategories,
    
  );

  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid, iOS: initialzationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
  );


  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  /// Dialog로 표시되어서 alert만 false foreground
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: false,
    badge: true,
    sound: true,
  );

  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;

  debugPrint('notification: ${notification.toString()}');
  
  // if (android != null && !kIsWeb) {
  if (Platform.isAndroid && notification != null && !kIsWeb) {

    Map<String, dynamic> data = message.data; //data 를 가져와서 파싱
    final String sid = data["sid"] ?? '';
    final String title = data["title"] ?? '';
    final String content = data["message"] ?? '';
    
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      title,
      content,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
        ),
      ),
      payload: data.toString()
    );

  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      /**
       * 확인 
       * 안드로이드 
       * 수신 : foreground
       * 
       * IOS
       * 수신 : foreground
       */
      NotificationController.fromRemoteMessage(message).showDialog();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      /**
       * 확인
       * 안드로이드
       * 클릭 : background
       * 
       * IOS 
       * 클릭 : background
       */
      NotificationController.fromRemoteMessage(message).showDialog();
    });

  }

  @override
  Widget build(BuildContext context) {
    
    return GetMaterialApp(
      home: IntroWidget(),
      getPages: [
        GetPage(name: Home.routeName, page: () => Home(), ),
        GetPage(name: IntroWidget.routeName, page: () => IntroWidget(), ),

        GetPage(name: GlanceView.routeName, page: () => GlanceView(), transition: Transition.downToUp, fullscreenDialog: true, ),
        GetPage(name: Photoview.routeName, page: () => Photoview(), transition: Transition.downToUp, fullscreenDialog: true,),

        GetPage(name: BoothIntro.routeName, page: () => const BoothIntro(), transition: Transition.rightToLeft, fullscreenDialog: true,), 
        GetPage(name: BoothScane.routeName, page: () => BoothScane(), transition: Transition.downToUp, fullscreenDialog: true,),  

        GetPage(name: VotingWidget.routeName, page: () => VotingWidget(), transition: Transition.downToUp, fullscreenDialog: true,),  
      ],
    );
  }
}