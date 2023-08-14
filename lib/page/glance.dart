import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';


import '../constants.dart';
import '../service/app_service.dart';
import '../controller/nav_item_controller.dart';
import '../data/ezv_item.dart';
import '../func_widget/make_header.dart';
import 'glance_view.dart';

class Glance extends StatefulWidget {

  static String routeName = '/glance';
  String url;

  Glance({super.key, required this.url});

  @override
  State<Glance> createState() => _GlanceState();
}

class _GlanceState extends State<Glance> {
  late final AppService _appService;
  late final NavItemController _navController;

  InAppWebViewController? webViewController;

  late String tab;
  late String mon;
  late String dayType;
  late EzvColor ezvColors;

  final ValueNotifier<bool> _isGuideShow = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    _navController = NavItemController.to;
    _appService = AppService.to;

    mon = _appService.mon ?? '';
    tab = _appService.tab ?? '';
    dayType = _appService.dayType ?? '1';

    ezvColors = _appService.getColor;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);

    webViewController?.loadUrl(
      urlRequest: URLRequest(
        url: Uri.parse('${widget.url}&tab=$tab'),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    // EzvDayItem ezvDayItem = _appService.getDay.where((element) => element.tab == tab).first;
    // String date = ezvDayItem.getDate;
    // String mon = DateFormat('MMM').format(DateTime.parse('2023-08-31'))
    

    List<EzvDayItem> dayList = _appService.getDay;

    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
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


    return Stack(
      children: [
        Scaffold(
          appBar: AppHeader(navController: _navController),
          body: Column(
            children: [
              AppHeaderSub(
                navController: _navController,
                title: 'Program at a Glance',
              ),
              daySelType(dayType, dayList),
              Expanded(
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    iosHttpShouldHandleCookies: true,
                    url: Uri.parse('${widget.url}&tab=$tab'),
                  ),
                  initialOptions: options,
                  onWebViewCreated: (controller) async {
                    webViewController = controller;
                    webViewController?.addJavaScriptHandler(
                      handlerName: 'handleUrlChange',
                      callback: (input) async {
                        final nextUrl = input.first as String;
                        debugPrint('웹뷰g [addJavaScriptHandler]: $nextUrl');
                      },
                    );
                  },
                  onLoadStop: (contoller, url) {
                    debugPrint('웹뷰g [onLoadStop]: $url');
                  },
                  onUpdateVisitedHistory: (controller, url, check) {
                    debugPrint('웹뷰g [onUpdateVisitedHistory]: $url');
                  },
                  shouldOverrideUrlLoading: (controller, action) async {
                    final url = action.request.url.toString();
                    debugPrint('웹뷰g [shouldOverrideUrlLoading]: $url.');

                    if (url.contains('glance_sub.php')) {
                      Get.toNamed(GlanceView.routeName, arguments: {'url': url});
                      return NavigationActionPolicy.CANCEL;
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                ),
                // child: WebviewWidget(url: widget.url, title: 'glance', appBarShow: false,),
              ),
            ],
          ),
        ),

        ValueListenableBuilder(
          valueListenable: _isGuideShow, 
          builder:(BuildContext context, bool value, _) {
            return Visibility(
              visible: _isGuideShow.value,
              child: GestureDetector(
                onTap: () {
                  _isGuideShow.value = false;
                },
                child: Container(                
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withAlpha(100),
                  // child: Center(child: Text('hello', style: TextStyle(color: Colors.white),)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        
                        constraints:const BoxConstraints(maxWidth: 140, minWidth: 100, maxHeight: 140, minHeight: 100),
                        child: Image.asset(
                          'assets/images/common/ico_click.png',
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
              
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Touch on a session to check the details.\nUse your fingers to zoom in/out.',
                        textScaleFactor: 1.0,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // if (_isGuideShow) ...[
        //   GestureDetector(
        //     onTap: () {
        //       setState(() {
        //         _isGuideShow = false;
        //       });
        //     },
        //     child: Container(
        //       alignment: Alignment.center,
        //       width: MediaQuery.of(context).size.width,
        //       height: MediaQuery.of(context).size.height,
        //       color: Colors.black.withAlpha(100),
        //       // child: Center(child: Text('hello', style: TextStyle(color: Colors.white),)),
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           ConstrainedBox(
        //             // constraints: const BoxConstraints(maxWidth: 100),
        //             constraints:
        //                 const BoxConstraints(maxWidth: 140, minWidth: 100, maxHeight: 140, minHeight: 100),
        //             // child: Image.asset(
        //             //   'assets/images/background/ico_click.png',
        //             //   fit: BoxFit.contain,
        //             //   width: MediaQuery.of(context).size.width * 0.25,
        //             // ),

        //             child: Placeholder(),

        //           ),
        //           const SizedBox(
        //             height: 20,
        //           ),
        //           const Text(
        //             'Touch on a session to check the details.\nUse your fingers to zoom in/out.',
        //             textScaleFactor: 1.0,
        //             textAlign: TextAlign.center,
        //             style: TextStyle(
        //                 color: Colors.white,
        //                 fontWeight: FontWeight.bold,
        //                 fontSize: 18.0),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ],
      ],
    );
  }

  Widget daySelType(String dayType, List<EzvDayItem> dayList) {
    if(dayType == '1') {
      return daySelType1(dayList); 
    } else {
      return daySelType2(dayList);
    }
  }

  Widget daySelType1(List<EzvDayItem> dayList) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          for (EzvDayItem item in dayList) ...[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if( item.tab != '-1' ) {
                    setState(() {
                      tab = item.tab;
                    });
                  }
                },
                child: Container(
                  color: (tab == item.tab) ? ezvColors.menuBgOn : ezvColors.menuBg,
                  child: Center(
                    child: Text(
                      item.name,
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        color: (tab == item.tab) ? ezvColors.menuFontOn : ezvColors.menuFont,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),

    );
  }

  Container daySelType2(List<EzvDayItem> dayList) {
    return Container(
      color: const Color(0xffe3e5ec),
      padding: const EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            mon,
            textScaleFactor: 1.0,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (EzvDayItem item in dayList) ...[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: 50,
                    child: Text(
                      item.week,
                      textScaleFactor: 1.0,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (EzvDayItem item in dayList) ...[
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if( item.tab != '-1' ) {
                        setState(() {
                          tab = item.tab;
                        });
                      }
                    },
                    child: (tab == item.tab)
                        ? Container(
                            width: 50,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              color: Color(0xff2d63bb),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              item.day,
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            width: 50,
                            child: Text(
                              item.day,
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: item.tab == '-1'
                                      ? const Color(0xff9fa1a9)
                                      : null),
                            ),
                          ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
