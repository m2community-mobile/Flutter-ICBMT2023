
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../controller/nav_item_controller.dart';
import '../constants.dart';
import '../data/ezv_item.dart';
import '../main.dart';
import '../page/image_view.dart';
import '../page/pdf_view.dart';
import '../service/app_service.dart';

class WebviewSetting {

  InAppWebViewController webViewController;
  NavItemController? navController;

  WebviewSetting(this.webViewController, {this.navController});

  Future<NavigationActionPolicy> overRideUrlLoading(InAppWebViewController controller, NavigationAction action) async {
    final url = action.request.url.toString();
    debugPrint('웹뷰s [shouldOverrideUrlLoading]: $url.');

    if (url.endsWith('back.php')) {
      final canGoBack = await _canGoback();
      log(canGoBack.toString());
      if (canGoBack == true) {
        controller.goBack();
      
      } else {
        log(navController.toString());

        if(navController == null) {
          Get.back();
        } else {
          navController!.goHome();
        }
      }
      return NavigationActionPolicy.CANCEL;

    } else if (url.startsWith('https://google.com/map') || url.startsWith('https://www.google.com/map')) {
      //IOS 구글맵 아이프레임의 경우 새창에 떠서 추가
      return NavigationActionPolicy.ALLOW;

    } else if (url.startsWith('http')) {
      
      if (url.contains(eventSiteDomain) || url.contains('ezv.kr')) {

        if(url.contains('add_alarm.php')) {
          setAlarm(url);
          return NavigationActionPolicy.CANCEL;

        } else if (url.contains("remove_alarm.php")) {
          removeAlarm(url);
          return NavigationActionPolicy.CANCEL;

        } else if ( url.endsWith('.jpg') || url.endsWith('.png') || url.endsWith('.gif') ) {
          
          Get.to(() => ImageView(imageUrl: url,));
          return NavigationActionPolicy.CANCEL;

        } else if ( url.endsWith('.pdf') ) {

          Get.to(() => PDFViewer(url: url,));
          return NavigationActionPolicy.CANCEL;
        }

        return NavigationActionPolicy.ALLOW;
      }
      browserLaunch(url);
      return NavigationActionPolicy.CANCEL;
    }

    return NavigationActionPolicy.ALLOW;
  }

  

  Future<void> browserLaunch(url) async {
    final Uri linkUrl = Uri.parse(url);

    if (!await launchUrl(linkUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $linkUrl');
    }
  }

  Future<bool> _canGoback() async {
    return await webViewController.canGoBack();
  }

  void removeAlarm(String url) async {
    List<String> temp = url.split('?');
    final Map<String, dynamic> data = Uri.splitQueryString(temp[1]);
    final String sid = data['sid'];

    await flutterLocalNotificationsPlugin.cancel(int.parse(sid));
    Fluttertoast.showToast(msg: constTextRemoveAlarm);
  }

  void setAlarm(String url) async {

    tz.initializeTimeZones();

    
    

    List<String> temp = url.split('?');
    final Map<String, dynamic> data = Uri.splitQueryString(temp[1]);

    final String sid = data['sid'];
    final String tab = data['tab'];
    final String subject = data['subject'];
    final String period_time = data['time'];    
    final String stime = period_time.split('-')[0];


    final AppService appService = AppService.to;
    EzvDayItem ezvDayItem = appService.getDay.where((element) => element.tab == tab).first;
    String alarmDate = ezvDayItem.getDate;
    

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);


    Map payload = {'type':'program', 'sid': sid, 'title': constTextAlarm, 'content': subject, 'tab': tab};

    // final alarmTime = tz.TZDateTime.now(tz.getLocation('Asia/Seoul')).add(const Duration(seconds: 10));
    // final alarmTime = tz.TZDateTime.parse(tz.getLocation('Asia/Seoul'), '2023-07-04 $stime:00').subtract(const Duration(minutes: 10));
    final alarmTime = tz.TZDateTime.parse(tz.getLocation('Asia/Seoul'), '$alarmDate $stime:00').subtract(const Duration(minutes: 10));
    
    if(alarmTime.isAfter(tz.TZDateTime.now(tz.getLocation('Asia/Seoul')))) {

      await flutterLocalNotificationsPlugin.zonedSchedule(
            int.parse(sid),
            constTextAlarm,
            subject,
            // tz.TZDateTime.now(tz.getLocation('Asia/Seoul')).add(const Duration(seconds: 20)),
            alarmTime,
            const NotificationDetails(
                android: AndroidNotificationDetails(
                  'full screen channel id', 'full screen channel name',
                  channelDescription: 'full screen channel description',
                  priority: Priority.high,
                  importance: Importance.high,
                  fullScreenIntent: true,),
                ),
                payload: jsonEncode(payload),
                androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
                uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
            );
    }

    Fluttertoast.showToast(msg: constTextAddAlarm);

  }

  static InAppWebViewGroupOptions get options => InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      // clearCache: true,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
      disallowOverScroll: true,
    ),
  );
}
