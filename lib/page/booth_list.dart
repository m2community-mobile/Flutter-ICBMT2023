import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:icbmt2023/func_widget/platform_widget.dart';
import 'package:icbmt2023/service/app_service.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../controller/nav_item_controller.dart';
import '../func_widget/make_header.dart';
// import '../func_widget/simple_webview.dart';
import '../func_widget/permission_check.dart';
import '../func_widget/web_view_setting.dart';
import 'booth_intro.dart';
import 'booth_scane.dart';
// import 'booth_scane.dart';

class BoothList extends StatefulWidget {
  static String routeName = '/booth/list';

  BuildContext parentContext;
  BoothList(this.parentContext, {super.key});
  
  final ValueNotifier<int> _stampCnt = ValueNotifier<int>(0); // ValueNotifier 변수 선언
  final ValueNotifier<String> _eventState = ValueNotifier<String>(''); // ValueNotifier 변수 선언


  @override
  State<BoothList> createState() => _BoothListState();
}

class _BoothListState extends State<BoothList> {
  // late final WebViewController _controller;
  final AppService _appService = AppService.to;
  final NavItemController _navController = NavItemController.to;

  late InAppWebViewController webViewController;
  late WebviewSetting webviewSetting;
  InAppWebView? inAppWebView;

  @override
  void initState() {
    super.initState();

    debugPrint('user_sid : ${_appService.userSid}');

    String url = constUrlBoothEvent;
    url = url.contains('{deviceid}')
        ? url.replaceAll('{deviceid}', _appService.deviceId)
        : url;
    url = url.contains('{user_sid}')
        ? url.replaceAll('{user_sid}', _appService.userSid.toString())
        : url;

    inAppWebView = InAppWebView(
      initialUrlRequest: URLRequest(
        // iosHttpShouldHandleCookies: true,
        url: Uri.parse(url),
      ),
      initialOptions: WebviewSetting.options,
      onWebViewCreated: (controller) async {
        webViewController = controller;
        webviewSetting = WebviewSetting(webViewController);
        // webViewController?.addJavaScriptHandler(
        //   handlerName: 'handleUrlChange',
        //   callback: (input) async {
        //     final nextUrl = input.first as String;
        //     debugPrint('웹뷰 [addJavaScriptHandler]: $nextUrl');
        //   },
        // );
      },
      onLoadStop: (contoller, url) {
        debugPrint('GlanceView() [onLoadStop]: $url');
      },
      onUpdateVisitedHistory: (controller, url, check) {
        debugPrint('GlanceView() [onUpdateVisitedHistory]: $url');
      },
      shouldOverrideUrlLoading:(_, navigationAction) async {
        return await webviewSetting.overRideUrlLoading(webViewController, navigationAction);
      },
    );

    getStampCnt();
  }

  void getStampCnt() async {
    // widget.stampCnt;

    Map<String, String> sendData = {
      'deviceid' : _appService.deviceId,
      'user_sid' : _appService.userSid.toString(),
    };

    final dio = Dio();
    final response = await dio.get(constUrlBoothEventCnt, queryParameters: sendData);
    final result = jsonDecode(response.toString());

    int giftYn = 0;
    if(result['gift'] != null) {
      if(result['gift'] is String) {
        giftYn = int.parse(result['gift']);
      } else {
        giftYn = result['gift'];
      }
    }

    if( giftYn > 0) {
      log('C', name: 'booth state');
      widget._eventState.value = 'C';
    } else if( result['eventYN'] == 'Y') {
      log('Y', name: 'booth state');
      widget._eventState.value = 'Y';
    } else {
      log('N', name: 'booth state');
      widget._eventState.value = 'N';
    }
// widget._eventState.value = 'Y';


    widget._stampCnt.value = int.parse(result['cnt'] ?? 0);
  }



  @override
  void didUpdateWidget(covariant BoothList oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("BoothList: didUpdateWidget()");

    getStampCnt();
  }

  
  


  Widget setStampCnt() {
    return ValueListenableBuilder(
      valueListenable: widget._stampCnt, 
      builder: (BuildContext context, int value, Widget? child) {
        return Text('$value', 
          textScaleFactor: 1.0,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Widget setFooterButton(double footerBtnHeight) {
    return ValueListenableBuilder(
      valueListenable: widget._eventState, 
      builder: (BuildContext context, String value, Widget? child) {  
        
        if(value == 'Y') {
          return Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(20, 47, 89, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                height: footerBtnHeight + 65,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text('YOU COLLECTED ALL THE STAMPS!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    const AutoSizeText(
                      'YOU COLLECTED ALL THE STAMPS!',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 5,),
                    const AutoSizeText(
                      'Show this screen to staff at the information desk located on the 1st floor, and you will win a gift',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20,),

                    GestureDetector(
                      onTap: () {
                        PlatformWidget.dialog(
                          title: 'Will you receive a gift', 
                          content: const Text('(※ Only staff click this button)', textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();                              
                              },
                              child: const Text("Close"),
                            ),
                            TextButton(
                              onPressed: () async {
                                Map<String, String> sendData = {
                                  'deviceid' : _appService.deviceId,
                                  'user_sid' : _appService.userSid.toString(),
                                };
                                print(constUrlBoothEventGift);
                                final dio = Dio();
                                final response = await dio.get(constUrlBoothEventGift, queryParameters: sendData);
                                print(response.toString());
                                Get.back();
                                getStampCnt();
                              },
                              child: const Text("Confirm"),
                            ),
                          ]
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        height: 72,
                        width: double.infinity,
                        child: const Center(child: 
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                spacing: 3,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Icon(Icons.wallet_giftcard_rounded, color: Color.fromRGBO(39, 48, 80, 1),),
                                  Text('Gift Voucher', style: TextStyle(fontSize: 16, wordSpacing: -1, color: Color.fromRGBO(39, 48, 80, 1), fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Text('(※ Only staff can click this button)', style: TextStyle(color: Color.fromRGBO(237, 28, 36, 1), fontWeight: FontWeight.bold),),
                            ],
                          )
                        ),
                      ),
                    ),

                  ],
                ),
            ),
          );
        } else if(value == 'N') {
          return Align(
            alignment: FractionalOffset.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                
                final permissionResult = await PermissionCheck().request(context, Permission.camera);
                if(permissionResult) {

                  Navigator.pushNamed(context, BoothScane.routeName)
                  .then((value) 
                  {
                    if(value == 'reload') {
                      // _controller.reload();
                      webViewController.reload();
                      getStampCnt();
                    }
                  });
                }
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(20, 47, 89, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                height: footerBtnHeight,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 55,
                      child: Center(
                        child: Text(
                          "Please scan the barcode of each booth",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        'assets/images/common/booth_icoScan@3x.png',
                        fit: BoxFit.contain,
                        width: 250,
                      ),
                      // child: Placeholder(),
                    ),
                    SizedBox(
                      height:
                          MediaQuery.of(widget.parentContext).padding.bottom + 13,
                    )
                  ],
                ),
              ),
            ),
          );
        } else if(value == 'C') {
          return Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(20, 47, 89, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              height: footerBtnHeight + 50,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(
                    height: 70,
                    child: Center(
                      child: Text(
                        "Thank you for joining the event!",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      'assets/images/icons/gift_comp@3x.png',
                      fit: BoxFit.contain,
                    ),                      
                  ),
                  SizedBox(
                      height:
                          MediaQuery.of(widget.parentContext).padding.bottom + 13,
                    )
                  
                ],
              ),
            ),
          );

        } else {
          return Container();
        }

      },
      
    );
  }

  

  @override
  Widget build(BuildContext context) {
    double footerBtnHeight =
        MediaQuery.of(widget.parentContext).padding.bottom + 120;
    double infoHeight = 110;

    return Scaffold(
      appBar: AppHeader(navController: _navController),
      body: Stack(
        children: [
          Positioned(
            child: Column(
              children: [
                AppHeaderSub(
                  navController: _navController,
                  title: 'Booth Stamp Event',
                ),
                Container(
                  height: infoHeight,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.05),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Wrap(
                              spacing: 7,
                              children: [
                                Image.asset(
                                  'assets/images/common/booth_buletTitle@2x.png',
                                  fit: BoxFit.contain,
                                ),
                                const Text(
                                  'Number of stamps collected :',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                setStampCnt(),
                              ],
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(BoothIntro.routeName);
                          // widget._stampCnt2.value++;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(13, 71, 161, 1),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          // padding: EdgeInsets.all(10),
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Center(
                            child: Wrap(
                              spacing: 7,
                              children: [
                                Image.asset(
                                  'assets/images/common/booth_icoScanInfo@2x.png',
                                  fit: BoxFit.contain,
                                  height: 20,
                                ),
                                const Text(
                                  'How to join the event?',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(
              top: constAppbarsubHeight + infoHeight,
              bottom: footerBtnHeight,
            ),
            // child: WebViewWidget(controller: _controller),
            child: inAppWebView,
          ),

          setFooterButton(footerBtnHeight),
          // if(widget._eventState.value == 'Y') ... [
          //   Align(
          //     alignment: FractionalOffset.bottomCenter,
          //     child: Container(
          //         decoration: const BoxDecoration(
          //           color: Color.fromRGBO(39, 48, 80, 1),
          //           borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(30.0),
          //             topRight: Radius.circular(30.0),
          //           ),
          //         ),
          //         padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
          //         height: footerBtnHeight + 45,
          //         width: double.infinity,
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             // Text('YOU COLLECTED ALL THE STAMPS!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

          //             const AutoSizeText(
          //               'YOU COLLECTED ALL THE STAMPS!',
          //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          //               maxLines: 1,
          //             ),
          //             const SizedBox(height: 10,),
          //             const AutoSizeText(
          //               'Show this screen to staff at the information desk located on the 1st floor, and you will win a gift',
          //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          //               maxLines: 2,
          //               textAlign: TextAlign.center,
          //             ),
          //             const SizedBox(height: 15,),

          //             Container(
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(28.0),
          //               ),
          //               height: 50,
          //               width: double.infinity,
          //               child: Center(child: 
          //                 Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: [
          //                     const Wrap(
          //                       spacing: 3,
          //                       crossAxisAlignment: WrapCrossAlignment.center,
          //                       children: [
          //                         Icon(Icons.wallet_giftcard_rounded, color: Color.fromRGBO(39, 48, 80, 1),),
          //                         Text('Gift Voucher', style: TextStyle(color: Color.fromRGBO(39, 48, 80, 1), fontWeight: FontWeight.bold),),
          //                       ],
          //                     ),
          //                     Text('(※ Only staff can click this button)', style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold),),
          //                   ],
          //                 )
          //               ),
          //             ),

          //           ],
          //         ),
          //     ),
          //   ),
          // ]
          // else if(widget._eventState.value == 'N') ... [
          //   Align(
          //     alignment: FractionalOffset.bottomCenter,
          //     child: GestureDetector(
          //       onTap: () async {
                  
          //         final permissionResult = await PermissionCheck().request(context, Permission.camera);
          //         if(permissionResult) {

          //           Navigator.pushNamed(context, BoothScane.routeName)
          //           .then((value) 
          //           {
          //             if(value == 'reload') {
          //               // _controller.reload();
          //               webViewController.reload();
          //               getStampCnt();
          //             }
          //           });
          //         }
          //       },
          //       child: Container(
          //         decoration: const BoxDecoration(
          //           color: Color.fromRGBO(39, 48, 80, 1),
          //           borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(30.0),
          //             topRight: Radius.circular(30.0),
          //           ),
          //         ),
          //         height: footerBtnHeight,
          //         width: double.infinity,
          //         child: Column(
          //           children: [
          //             const SizedBox(
          //               height: 55,
          //               child: Center(
          //                 child: Text(
          //                   "Please scan the barcode of each booth",
          //                   textScaleFactor: 1.0,
          //                   style: TextStyle(
          //                     color: Colors.white,
          //                     // fontWeight: FontWeight.w800,
          //                     fontSize: 18,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //             Expanded(
          //               child: Image.asset(
          //                 'assets/images/common/booth_icoScan@3x.png',
          //                 fit: BoxFit.contain,
          //                 width: 250,
          //               ),
          //               // child: Placeholder(),
          //             ),
          //             SizedBox(
          //               height:
          //                   MediaQuery.of(widget.parentContext).padding.bottom + 13,
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   )

          // ]

          // else if(widget._eventState.value == 'C') ... [
          //   Align(
          //     alignment: FractionalOffset.bottomCenter,
          //     child: Container(
          //       decoration: const BoxDecoration(
          //         color: Color.fromRGBO(39, 48, 80, 1),
          //         borderRadius: BorderRadius.only(
          //           topLeft: Radius.circular(30.0),
          //           topRight: Radius.circular(30.0),
          //         ),
          //       ),
          //       height: footerBtnHeight,
          //       width: double.infinity,
          //       child: Column(
          //         children: [
          //           const SizedBox(
          //             height: 55,
          //             child: Center(
          //               child: Text(
          //                 "Thank you for joining the event!",
          //                 textScaleFactor: 1.0,
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   // fontWeight: FontWeight.w800,
          //                   fontSize: 18,
          //                 ),
          //               ),
          //             ),
          //           ),
                    
          //         ],
          //       ),
          //     ),
          //   )

          // ]
          
        ],
      ),
    );
  }

  
}



// Future<void> scanBarcodeNormal() async {
  // String barcodeScanRes;
  // // Platform messages may fail, so we use a try/catch PlatformException.
  // try {
  //   barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //       '#ff6666', 'Cancel', true, ScanMode.BARCODE);
  //   print(barcodeScanRes);
  // } on PlatformException {
  //   barcodeScanRes = 'Failed to get platform version.';
  // }
// }
