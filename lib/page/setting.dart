import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../constants.dart';
import '../controller/nav_item_controller.dart';
import '../data/app_version.dart';
import '../func_widget/make_header.dart';
import '../func_widget/platform_widget.dart';
import '../service/app_service.dart';



class Setting extends StatefulWidget {

  BuildContext parentContext;

  Setting(this.parentContext, {super.key});

  static String routeName = '/setting';

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final NavItemController _navController = NavItemController.to;
  final AppService _appService = AppService.to;
  // final EzvItemController _ezvController = Get.find<EzvItemController>();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: '-',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  bool _updateAble = false;
  bool _receivePush = false;

  
  @override
  void initState() {
    super.initState();

    _initPackageInfo();
    _initGetPush();

  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();

    final storeAppVersion = await _appService.getStoreVersion();
    debugPrint('storeAppVersion : $storeAppVersion');

    _updateAble = AppVersion.isVersionhigher(info.version, storeAppVersion);
    

    setState(() {
      _packageInfo = info;
    });

  }

  Future<void> _initGetPush() async {
    final dio = Dio();
    final result = await dio.get(constUrlGetPush, queryParameters: {'deviceid': _appService.deviceId});

    setState(() {
      _receivePush = result.toString() == 'Y';
    });

  }

  Future<void> setPush() async {

    String val = _receivePush ? 'N' : 'Y';

    final dio = Dio();
    final result = await dio.get(constUrlSetPush, queryParameters: {'deviceid': _appService.deviceId, 'val': val});


    setState(() {
      _receivePush = !_receivePush;
    });

  }
  

  @override
  Widget build(BuildContext context) {
    // EzvColor ezvColors = _appService.getColor;
    // BuildContext? pContext = Home.homeKey.currentContext;

    return Scaffold(
      appBar: AppHeader(navController: _navController),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppHeaderSub(
            navController: _navController,
            title: 'Setting',
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xffF0F4F9),
              // color: Colors.grey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      textScaleFactor: 1.0,
                      'Receive the latest information of the $eventName in real time by clicking on the PUSH notification.'
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(width: 0.5, color: Color.fromRGBO(180, 180, 180, 1)),
                        bottom: BorderSide(width: 0.5, color: Color.fromRGBO(180, 180, 180, 1)),
                      )
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('PUSH', textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.bold),),
                        // Switch(value: _receivePush, onChanged: (value) {
                        //   setPush();
                        // }),
                        PlatformWidget.switchWidget(value: _receivePush, activeColor: const Color.fromRGBO(51, 155, 215, 1), onChanged: (value) {
                          setPush();
                        }),

                      ],
                    ),
                  ),

                  if(Platform.isIOS) ... [

                    const Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Text(
                        textScaleFactor: 1.0,
                        'Change your iPhone settings if you do not receive any notifications. iPhone > Setting > Notifications > Turn notifications for this app \'on\''
                      ),
                    ),

                  ],

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(width: 0.5, color: Color.fromRGBO(180, 180, 180, 1)),
                        bottom: BorderSide(width: 0.5, color: Color.fromRGBO(180, 180, 180, 1)),
                      )
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('App Version', textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.bold),),
                        Row(
                          children: [
                            _updateAble ?
                            GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                await PlatformWidget.goMarketStore();
                              },
                              child: Container(
                                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                padding: const EdgeInsets.all(5),
                                child: const Text('Update', textScaleFactor: 1.0,),
                              ),
                            ) :
                            Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                              padding: const EdgeInsets.all(5),
                              child: const Text('Latest', textScaleFactor: 1.0,),
                            ),
                            
                            const SizedBox(width: 10,),
                            Center(child: Text('V ${ _packageInfo.version}', textScaleFactor: 1.0,),),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () {
              
          //     PlatformWidget.dialog(title: constDialogLogoutTitle, content: constDialogLogout, actions: 
          //         [
          //           TextButton(
          //               onPressed: () => Get.back(),
          //               child: const Text(constTextNo, textScaleFactor: 1.0,),
          //           ),
          //           TextButton(
          //             onPressed: () async {
          //               final SharedPreferences prefs = await SharedPreferences.getInstance();
          //               await prefs.clear();

          //               Get.delete<EzvItemController>();
          //               Get.offAllNamed(IntroWidget.routeName);
          //             },
          //             child: const Text(constTextYes, textScaleFactor: 1.0,),
          //           ),
          //         ]
          //     );
          //   },
          //   child: Container(
              
          //     color: ezvColors.menuBgOn,
          //     height: MediaQuery.of(widget.parentContext).padding.bottom + 50,
          //     padding: EdgeInsets.only(
          //         bottom: MediaQuery.of(widget.parentContext).padding.bottom),
          //     width: double.infinity,
          //     child: const Center(
          //       child: Text(
          //         constTextLogout,
          //         textScaleFactor: 1.0,
          //         style: TextStyle(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 18),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
