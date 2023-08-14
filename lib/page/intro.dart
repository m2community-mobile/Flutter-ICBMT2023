import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../controller/notification_controller.dart';
import '../service/app_service.dart';
import '../controller/nav_item_controller.dart';
import '../main.dart';
import 'home.dart';

class IntroWidget extends StatefulWidget {
  static String routeName = '/';
  NotificationController? notificationController;

  IntroWidget({super.key});

  @override
  State<IntroWidget> createState() => _IntroWidgetState();
}

class _IntroWidgetState extends State<IntroWidget> {
  bool isLogined = false;

  Future<void> checkInitialMessage() async {

    /**
     * 확인
     * android
     * 클릭 : terminated
     *
     * IOS
     * 클릭 : terminated
    */
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    debugPrint('initialMessage : ${initialMessage?.data.toString()}');

    if (initialMessage?.data != null) {
      widget.notificationController = NotificationController.fromRemoteMessage(initialMessage!);
    }

    final NotificationAppLaunchDetails? details =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    final didNotificationLaunchApp =
      details?.didNotificationLaunchApp ?? false;

    if(didNotificationLaunchApp) {
      /**
       * 확인
       * 안드로이드 - alarm
       * 클릭 - foreground : X / background : X / terminated : O
       * 안드로이드 - push
       * 클릭 - foreground : X / background : X / terminated : X
       *
       * IOS - alarm
       * 클릭 - foreground : X / background : X / terminated : ?
       * IOS - push
       * 클릭 - foreground : X / background : X / terminated : ?
       */

      log('noti : didNotificationLaunchApp');
      debugPrint('noti : didNotificationLaunchApp');

      String response = details?.notificationResponse?.payload ?? '';
      log("payload $response");
      debugPrint("payload $response");

      Map<String, dynamic> data = jsonDecode(response);
      widget.notificationController = NotificationController(type: data['type'], sid: data['sid'], title: data['title'],  content: data['content'], tab: data['tab']);
    }
  }

  @override
  Widget build(BuildContext context) {
    // 가로모드 방지
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // 가로모드 방지

    return FutureBuilder(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // if (snapshot.connectionState != ConnectionState.done) {
        if (snapshot.hasData == false || snapshot.data == false) {
          return introPage(context);
          // dd.log('introPage');
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(fontSize: 15),
            ),
          );
        } else {
          return Home(notificationController: widget.notificationController,);
          // return Home();

          // if(isLogined) {
          //   return HomeWidget();
          // } else {
          //   return const LoginWidget();
          // }
        }
      },
    );
  }

  Future<bool> getData() async {
    
    final AppService appService = AppService.to;
    await appService.initEzvSetting();

    // if (await appService.isLogin()) {
    //   isLogined = true;
    // }
    isLogined = true;

    appService.setDeviceId();

    final navController = NavItemController.to;
    if (navController.isInitialized == false) {
      navController.init();
    }

    bool compareResult = await appService.compareVersion();

    if (compareResult == false) {
      return false;
    }

    await checkInitialMessage();
    await Future.delayed(const Duration(milliseconds: 2000));

    return true;
  }

  Widget introPage(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        //백그라운드 이미지
        image: DecorationImage(
          image: AssetImage(
            'assets/images/background/intro_bg@2x.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(
                40, MediaQuery.of(context).size.height * 0.15, 40, 0),
            child: Image.asset(
              'assets/images/background/intro_text01@2x.png',
              height: MediaQuery.of(context).size.height * 0.3,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(
                right: 25,
                bottom: MediaQuery.of(context).padding.bottom > 0  ? MediaQuery.of(context).padding.bottom : 10,
              ),
              child: Image.asset(
                'assets/images/background/intro_bottom_logo@2x.png',
                fit: BoxFit.contain,
                width: 190,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//
