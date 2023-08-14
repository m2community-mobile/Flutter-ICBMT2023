import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import 'platform_widget.dart';

class PermissionCheck {
  Future<bool> request(BuildContext context, Permission permission) async {

    if (permission == Permission.photos && Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        permission = Permission.storage;
      }
    }

    // print(await permission.status);

    PermissionStatus status = await permission.request();

    // PermissionStatus.denied
    // PermissionStatus.granted
    // PermissionStatus.limited
    // PermissionStatus.permanentlyDenied
    // PermissionStatus.restricted

    if (status == PermissionStatus.permanentlyDenied ||
        status == PermissionStatus.denied ||
        status == PermissionStatus.restricted) {
      if (context.mounted && 
        permission != Permission.notification
      ) {

        // showDialog(
        //   context: context,
        //   //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        //   barrierDismissible: false,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
        //       shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(10.0)),
        //       //Dialog Main Title
        //       title: const Text('Permission required'),
        //       content: Text('Please grant permission ${getName(permission)}.'),
        //       actions: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: const Text("Close"),
        //         ),
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //             openAppSettings();
        //           },
        //           child: const Text("Confirm"),
        //         ),
        //       ],
        //     );
        //   });

          PlatformWidget.dialog(title: 'Permission required', content: 'Please grant permission ${getName(permission)}.', actions: 
            [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    openAppSettings();
                  },
                  child: const Text("Confirm"),
                ),
            ]
        );
      }
      return false;
    }

    return true;
  }

  String getName(Permission permission) {

    if(permission == Permission.storage) {
      return "Storage";
    } else if(permission == Permission.camera) {
      return "Camera";
    } else if(permission == Permission.photos) {
      return "Photo";
    } else if(permission == Permission.notification) {
      return "Notification";
    }
    return "";
  }
}
