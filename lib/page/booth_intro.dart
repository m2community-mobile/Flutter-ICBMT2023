import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:get/get.dart';

import '../controller/nav_item_controller.dart';
import '../func_widget/web_view_setting.dart';
import 'booth_list.dart';


class BoothIntro extends StatefulWidget {
  const BoothIntro({super.key});
  static String routeName = '/booth';

  @override
  State<BoothIntro> createState() => _BoothIntroState();
}

class _BoothIntroState extends State<BoothIntro> {
  
  late InAppWebViewController webViewController;
  late WebviewSetting webviewSetting;
  InAppWebView? inAppWebView;

  @override
  void initState() {
    super.initState();
    inAppWebView = InAppWebView(
      initialUrlRequest: URLRequest(
        // iosHttpShouldHandleCookies: true,
        url: Uri.parse('https://ezv.kr:4447/icbmt2023/html/contents_dev/event.html'),
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
  }
  
  @override
  Widget build(BuildContext context) {

    final navController = NavItemController.to;
    final double bottomButtonHeight = 50 + MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      
      body: Stack(
        children: [
          Container(
            // color: const Color(0xff32466C),
            color: const Color.fromRGBO(5, 23, 83, 1),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: bottomButtonHeight),
            // child: WebViewWidget(controller: _webViewController),
            child: inAppWebView,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              child: GestureDetector(
                onTap: () {
                  Get.offNamed(BoothList.routeName);
                  navController.goDirect('booth_list');
                  Get.back();
                },
                child: Container(
                  height: bottomButtonHeight,
                  width: double.infinity,
                  color: const Color.fromRGBO(247, 149, 23, 1),
                  child: Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(top: 12.0),
                    child: const Text(
                      "Join the Event",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}