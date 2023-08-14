import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../func_widget/platform_widget.dart';

class AppVersion {
  String? min; //최소 버전  
  String? lastest; //마지막 버전
  String? lastestGuideShow; //마지막 버전 보다 낮을경우 알림표시여부

  AppVersion({this.min, this.lastest, this.lastestGuideShow});


  @override
  String toString() {
    // TODO: implement toString
    return 'min : $min lastest : $lastest, lastestGuideShow : $lastestGuideShow';
  }

  static bool isVersionhigher(String currentVersion, String lateVersion) {

    if(['', null].contains(currentVersion) || ['', null].contains(lateVersion)) {
      return false;
    }

    Version vCurrentVersion = Version.parse(currentVersion);
    Version vLateVersion = Version.parse(lateVersion);

    return (vCurrentVersion < vLateVersion);

  }

  Future<bool> compare(String version) async {

    if(!['', null].contains(min)) {

      Version currentVersion = Version.parse(version);
      Version latestVersion = Version.parse(min!);

      debugPrint('latestVersion: $latestVersion');
      debugPrint('currentVersion: $currentVersion');

      // 최소 버전 제한 : 업데이트 한 후에만 접근가능
      if(latestVersion > currentVersion) {

        PlatformWidget.dialog(title: constUpdateMustTitle, content: constUpdateMustContent, 
        actions: [
              TextButton(
                onPressed: () async {
                 
                  await PlatformWidget.goMarketStore();

                  if(Platform.isAndroid) {                  
                    SystemNavigator.pop();                  
                  } else {
                    exit(0);
                  }
                },
                child: const Text(constUpdateNOW, textScaleFactor: 1.0,),
              ),
            ]
          );

        return false;
      }
    }

    if(!['', null].contains(lastest) && lastestGuideShow == 'Y') {

      Version currentVersion = Version.parse(version);
      Version latestVersion = Version.parse(lastest!);

      debugPrint('latestVersion: $latestVersion');
      debugPrint('currentVersion: $currentVersion');


      if(latestVersion > currentVersion) {

        return await PlatformWidget.dialogReturnResult(title: constUpdateTitle, content: constUpdateContent, 
        actions: [
            TextButton(
              onPressed: () async {
                Get.back(result: true);
              },
              child: const Text(constUpdateLater, textScaleFactor: 1.0,),
            ),
            TextButton(
              onPressed: () async {
                Get.back(result: false);
                
                await PlatformWidget.goMarketStore();

                if(Platform.isAndroid) {                  
                  SystemNavigator.pop();                  
                } else {
                  exit(0);
                }
                
              },
              child: const Text(constUpdateNOW, textScaleFactor: 1.0,),
            ),
          ],
        );
        
      }

    }

    return true;    
  }

  
}