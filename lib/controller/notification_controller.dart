

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../func_widget/platform_widget.dart';
import '../constants.dart';
import 'nav_item_controller.dart';

class NotificationController {

  final String type;
  final String sid;
  final String title;
  final String content;
  String? tab;

  NotificationController({
    required this.type,
    required this.sid,
    required this.title,
    required this.content,
    this.tab,
  });

  NotificationController.fromRemoteMessage(
    RemoteMessage message
  ) :
    type = 'notice',
    sid = message.data['sid'],
    title = message.data['title'],
    content = message.data['message'];
  

  void showDialog() {

    final navController = NavItemController.to;
    
    if(type == 'notice') {
      // Get.dialog(
      //   AlertDialog(
      //     // key: Key(sid),
      //     shape: constDialogShape,
      //     title: Text(title, textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.bold),),
      //     content: Text(content, textScaleFactor: 1.0,),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Get.back(),
      //         child: const Text(constTextNo, textScaleFactor: 1.0,),
      //       ),
      //       TextButton(
      //         onPressed: () async {
      //           // movePage("detailNotice");
      //           navController.webView('notice_view', param:{'sid': sid});
      //           Get.back();                
      //         },
      //         child: const Text(constTextYes, textScaleFactor: 1.0,),
      //       ),
      //     ],
      //   ),
      // ).then((val){
      //   Get.back(closeOverlays: true);
      // });

      PlatformWidget.dialog(title: title, content: content, actions: 
        [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(constTextNo, textScaleFactor: 1.0,),
          ),
          TextButton(
            onPressed: () async {
              // movePage("detailNotice");
              navController.webView('notice_view', param:{'sid': sid});
              Get.back();                
            },
            child: const Text(constTextYes, textScaleFactor: 1.0,),
          ),
        ]
      );

    } else if(type == 'program') {

      // Get.dialog(
      //   AlertDialog(
      //     // key: Key(sid),
      //     shape: constDialogShape,
      //     title: Text(title, textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.bold),),
      //     content: Text(content, textScaleFactor: 1.0,),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Get.back(),
      //         child: const Text(constTextNo, textScaleFactor: 1.0,),
      //       ),
      //       TextButton(
      //         onPressed: () async {
      //           // movePage("detailNotice");
      //           navController.webView('program', param: {'tab': tab}, anchor:'session$sid');
      //           Get.back();                
      //         },
      //         child: const Text(constTextYes, textScaleFactor: 1.0,),
      //       ),
      //     ],
      //   ),
      // ).then((val){
      //   Get.back(closeOverlays: true);
      // });

      PlatformWidget.dialog(title: title, content: content, actions: 
        [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(constTextNo, textScaleFactor: 1.0,),
          ),
          TextButton(
            onPressed: () async {
              // movePage("detailNotice");
              navController.webView('program', param: {'tab': tab}, anchor:'session$sid');
              Get.back();                
            },
            child: const Text(constTextYes, textScaleFactor: 1.0,),
          ),
        ]
      );
    }
    
  }

}

  


