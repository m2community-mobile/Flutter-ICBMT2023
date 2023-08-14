import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../func_widget/web_view_setting.dart';

class GlanceView extends StatefulWidget {
  static String routeName = '/glance/view';

  @override
  State<GlanceView> createState() => _GlanceViewState();
}

class _GlanceViewState extends State<GlanceView> {

  late InAppWebViewController webViewController;
  late WebviewSetting webviewSetting;
  InAppWebView? inAppWebView;


  @override
  void initState() {
    
    super.initState();

    String url = Get.arguments['url'] ?? '';
    url =
        url.contains('glance_sub.php') ? '$url&title=Program at a Glance' : url;

    // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    //   crossPlatform: InAppWebViewOptions(
    //     useShouldOverrideUrlLoading: true,
    //     mediaPlaybackRequiresUserGesture: false,
    //   ),
    //   android: AndroidInAppWebViewOptions(
    //     useHybridComposition: true,
    //   ),
    //   ios: IOSInAppWebViewOptions(
    //     allowsInlineMediaPlayback: true,
    //     disallowOverScroll: true,
    //   ),
    // );

    inAppWebView = InAppWebView(
      initialUrlRequest: URLRequest(
        iosHttpShouldHandleCookies: true,
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
        String hurl = url.toString();

        // 상단 title 표시하기 위해 추가
        if (hurl.contains('session/view.php') && !hurl.contains('title=')) {
          controller.loadUrl(
              urlRequest: URLRequest(
                  url: Uri.parse('$hurl&title=Program at a Glance')));
        }
        debugPrint('GlanceView() [onUpdateVisitedHistory]: $url');
      },
      shouldOverrideUrlLoading:(_, navigationAction) async {
        return await webviewSetting.overRideUrlLoading(webViewController, navigationAction);
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: appBarBackgoundColor,
      //   title: const Text('Program at a Glance'),

      //   leading: GestureDetector(
      //     child: constIconBack,
      //     onTap: () {
      //       _goback();
      //     },
      //   ),
      //   actions: [
      //     CircleAvatar(
      //       backgroundColor: Colors.grey.shade400,
      //       radius: 20,
      //       child: IconButton(
      //         padding: EdgeInsets.zero,
      //         icon: const Icon(Icons.close_rounded),
      //         color: Colors.white,
      //         onPressed: () {
      //           Get.back();
      //         },
      //       ),
      //     ),
      //   ],
      // ),

      // body: Container(
      //   margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.bottom),
      //   child: inAppWebView,
      // ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: inAppWebView,
          ),
          Positioned(
            right: 5,
            top: MediaQuery.of(context).padding.top + 5,
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade400,
              radius: 15,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close_rounded,),
                color: Colors.white,
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
