import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../controller/nav_item_controller.dart';
import '../func_widget/web_view_setting.dart';
import 'make_header.dart';

class WebviewWidget extends StatefulWidget {
  final String title;
  String url;
  // final bool appBarShow;

  // WebviewWidget({
  //   super.key, required this.title, required this.url, 
  //   appBarShow
  // }) : appBarShow = appBarShow ?? true;
  WebviewWidget({super.key, required this.title, required this.url,});

  @override
  State<WebviewWidget> createState() => _WebviewWidgetState();
}

class _WebviewWidgetState extends State<WebviewWidget> {
  final NavItemController _navController = NavItemController.to;

  late InAppWebViewController webViewController;
  late WebviewSetting webviewSetting;
  late InAppWebView inAppWebView;

  final ValueNotifier<bool> _isLoadingShow = ValueNotifier<bool>(true);
  
  @override
  void initState() {
    inAppWebView = InAppWebView(
      initialUrlRequest: URLRequest(
        // iosHttpShouldHandleCookies: true,
        url: Uri.parse(widget.url),
      ),
      initialOptions: WebviewSetting.options,
      onWebViewCreated: (controller) async {
        webViewController = controller;
        webviewSetting = WebviewSetting(webViewController, navController: _navController);
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

    super.initState();
  }

  @override
  void didUpdateWidget(covariant WebviewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    print("didupdated");

    if (oldWidget.url != widget.url) {
      webViewController.loadUrl(
        urlRequest: URLRequest(
          url: Uri.parse(widget.url),
        ),
      );
    }
  }

  

  @override
  Widget build(BuildContext context) {
    
    return WillPopScope(
      // 뒤로가기시 앱종료 방지
      onWillPop: () async {
        if (await webViewController.canGoBack()) {
          webViewController.goBack();
        } else {
          _navController.goHome();
        }
        return false;
      },
      child: Scaffold(       
        appBar: AppHeader(navController: _navController),
        // appBar: widget.appBarShow ? AppHeader(navController: _navController) : null,
        body: Stack(
          children: [ 
            InAppWebView(
              initialUrlRequest: URLRequest(
                // iosHttpShouldHandleCookies: true,
                url: Uri.parse(widget.url),
              ),
              initialOptions: WebviewSetting.options,
              onWebViewCreated: (controller) async {
                webViewController = controller;
                // webViewController?.addJavaScriptHandler(
                //   handlerName: 'handleUrlChange',
                //   callback: (input) async {
                //     final nextUrl = input.first as String;
                //     debugPrint('웹뷰 [addJavaScriptHandler]: $nextUrl');
                //   },
                // );
                webviewSetting = WebviewSetting(webViewController, navController: _navController);
              },
              onLoadStop: (controller, url) {
                debugPrint('웹뷰 [onLoadStop]: $url');
                _isLoadingShow.value = false;
              },
              onUpdateVisitedHistory: (controller, url, check) {
                String hurl = url.toString();
              
                debugPrint('웹뷰 [onUpdateVisitedHistory]: $url');
              
                if(url.toString().contains('/post.php')) {
                  if(Platform.isAndroid) {
                    // controller.android.clearHistory();
                    controller.goBack();
                  }
                }             
              },
              shouldOverrideUrlLoading:(_, navigationAction) async {
                return await webviewSetting.overRideUrlLoading(webViewController, navigationAction);
              },
            ),
            
            ValueListenableBuilder(
            valueListenable: _isLoadingShow, 
            builder:(BuildContext context, bool value, _) {
              return Visibility(
                visible: _isLoadingShow.value,
                child: Container( color: Colors.white, child: const Center(child: CircularProgressIndicator(),), ),
              );
            }
            ),
          ],
        ),
      ),
    );
  }
}
