import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class PlatformWidget {

  static Widget switchWidget({required bool value, required Function(bool?) onChanged, Color? activeColor}) {

    if(Platform.isAndroid) {
      return Switch(value: value, onChanged: onChanged, activeColor: activeColor,);
    } else {
      return CupertinoSwitch(value: value, onChanged: onChanged, activeColor: activeColor,);
    }
  }

  static void dialog({required String title, required dynamic content, required List<Widget> actions}) {

    Text dialogContent;

    if(content is String) {
      dialogContent = Text(content, textScaleFactor: 1.0,);
    } else if(content is Text) {
      dialogContent = content;
    } else {
      dialogContent = const Text("");
    }

    if(Platform.isAndroid) {
      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: constDialogShape,
          title: Text(title, textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.bold),),
          // content: Text(content, textScaleFactor: 1.0,),
          content: dialogContent,
          actions: actions,
        )
      );
    } else {
      Get.dialog(
        barrierDismissible: false,
        CupertinoAlertDialog(
          title: Text(title, textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.bold),),
          // content: Text(content, textScaleFactor: 1.0,),
          content: dialogContent,
          actions: actions,
        )
      );
    }
  }

  static Future<bool> dialogReturnResult({required String title, required String content, required List<Widget> actions}) async {

    if(Platform.isAndroid) {
      return await Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape: constDialogShape,
          title: Text(title, textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.bold),),
          content: Text(content, textScaleFactor: 1.0,),
          actions: actions,
        )
      );
    } else {
      return await Get.dialog(
        barrierDismissible: false,
        CupertinoAlertDialog(
          title: Text(title, textScaleFactor: 1.0, style: const TextStyle(fontWeight: FontWeight.bold),),
          content: Text(content, textScaleFactor: 1.0,),
          actions: actions,
        )
      );
    }
  }


  static Future<void> goMarketStore() async {

    if(Platform.isAndroid) {
      // final Uri linkUrl = Uri.parse('market://details?id=com.m2comm.icorl2023'); //앱 선택이 뜸 (구글 스토어에만 쓸거라 안씀)
      final Uri linkUrl = Uri.parse('https://play.google.com/store/apps/details?id=$bundleIdAndroid');
      if (!await launchUrl(linkUrl, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch $linkUrl');
      }
    } else if(Platform.isIOS) {

      String url = 'https://itunes.apple.com/lookup?bundleId=$bundleIdIOS';

      final dio = Dio();
      final Options options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      var results = await dio.get(url, options: options);

      Map<String, dynamic> result = jsonDecode(results.data);
      // print(result);
      
      if (result['resultCount'] > 0 &&
          result['results'] != null &&
          result['results'].length > 0) {
        // print ('trackId : ${result['results'][0]['trackId'] ?? ''}');

        // final Uri linkUrl = Uri.parse('itms-apps://itunes.apple.com/app/id1517778153');
        final linkUrl = Uri.parse('https://apps.apple.com/app/id${result['results'][0]['trackId']}');

        if (!await launchUrl(linkUrl, mode: LaunchMode.externalApplication)) {
          throw Exception('Could not launch $linkUrl');
        }
      }

    }


    
  }
}