

import 'dart:developer';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/ezv_item.dart';
import '../page/booth_list.dart';
import '../page/glance.dart';
import '../page/index.dart';
import '../page/photo_list.dart';
import '../page/setting.dart';
import '../service/app_service.dart';
import '../constants.dart';
import '../data/nav_item.dart';
import '../func_widget/web_view.dart';

class NavItemController extends GetxController {

  static NavItemController get to => Get.isRegistered<NavItemController>() ? Get.find<NavItemController>() : Get.put(NavItemController());
  static GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  bool isPageLoading = false;

  final RxBool _isInitialized = false.obs;
  final RxList<NavItem> _navItems = <NavItem>[].obs;
  final RxBool _programMenuSelected = false.obs;
  String _currentPage = 'home';  
  int _webviewIndex = -1;
  Map<String, dynamic> _params = {};
  String _anchor = "";


  bool get isInitialized => _isInitialized.value;
  List<NavItem> get navItems => _navItems;
  bool get programMenuSelected => _programMenuSelected.value;
  String get currentPage => _currentPage;
  int get webviewIndex => _webviewIndex;
  Map get params => _params;
  String get anchor => _anchor;


  // Future<String> transUrl(String url) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final String deviceId = prefs.getString('deviceid') ?? "";
  //   final int userSid = prefs.getInt('user_sid') ?? 0;

  //   url = url.contains('{deviceid}')
  //       ? url.replaceAll('{deviceid}', deviceId)
  //       : url;
  //   url = url.contains('{user_sid}')
  //       ? url.replaceAll('{user_sid}', userSid.toString())
  //       : url;

  //   if(params.isNotEmpty) {
  //     var pParam = params as Map<String, dynamic>;
  //     String param = Uri(queryParameters: pParam).query;

  //     url = url.contains('?')
  //         ? "$url&$param"
  //         : "$url?$param";
  //   }

  //   if(anchor != "") {
  //     url = url + "#$anchor";
  //   }
    
  //   return url;
  // }
  String transUrl(String url) {

    final AppService appService = AppService.to;

    url = url.contains('{deviceid}')
        ? url.replaceAll('{deviceid}', appService.deviceId)
        : url;
    url = url.contains('{user_sid}')
        ? url.replaceAll('{user_sid}', appService.userSid.toString())
        : url;

    if(params.isNotEmpty) {
      var pParam = params as Map<String, dynamic>;
      String param = Uri(queryParameters: pParam).query;

      url = url.contains('?')
          ? "$url&$param"
          : "$url?$param";
    }

    if(anchor != "") {
      url = '$url#$anchor';
    }
    
    return url;
  }

  bool isCurrentMenuOpen(String currentMenuNum) {
    
    if (currentPage == 'webview') {
      return currentMenuNum == ConstWebPageList().getMenuNum(webviewIndex);
    } else if(currentPage == 'glance') {
      return webviewIndex == 0 && currentMenuNum == '2';
    }

    return false;
  }



  // Future<Widget> get widget async {

  //   log('currentPage: $currentPage');

  //   if(currentPage == 'webview') {
  //     String title;
  //     String url;

  //     log('webviewIndex: $webviewIndex');

  //     if (webviewIndex > -1) {
  //       title = ConstWebPageList().webViewPages[webviewIndex].title;
  //       url = ConstWebPageList().webViewPages[webviewIndex].url;
   
  //     } else {
  //       title = "title";
  //       url = "url";
  //     }

  //     url = await transUrl(url);

  //     return WebviewWidget(
  //       title: title,
  //       url: url,
  //     );

  //   } else if(currentPage == "home") {
  //     return IndexPage();
  //   } else if(currentPage == "glance") {
  //     String url = constUrlGlance;
  //     url = await transUrl(url);
  //     return Glance(url: url);
  //   } else {
  //     return Container();
  //   }
  // }

  Widget getWidget(BuildContext context) {

    log('currentPage: $currentPage');

    if(currentPage == 'webview') {
      String title;
      String url;

      log('webviewIndex: $webviewIndex');

      if (webviewIndex > -1) {
        title = ConstWebPageList().webViewPages[webviewIndex].title;
        url = ConstWebPageList().webViewPages[webviewIndex].url;
   
      } else {
        title = "title";
        url = "url";
      }

      url = transUrl(url);

      return WebviewWidget(
        title: title,
        url: url,
      );

    } else if(currentPage == "home") {
      return IndexPage();
    } else if(currentPage == "setting") {
      return Setting(context);
    } else if(currentPage == "glance") {
      String url = constUrlGlance;
      url = transUrl(url);
      return Glance(url: url);
    } else if (currentPage == 'photo_list') {
      return PhotoList();
    } else if (currentPage == 'booth_list') {
      return BoothList(context);
    } else {
      return Container();
    }
  }


  

  @override
  void onClose() {
    _isInitialized.value = false;
    super.onClose();
  }

  
  void init() {
    if(_isInitialized.value == false) {
      setMenu();
      _isInitialized.value = true;

      debugPrint('NavItemController initialize!!');
    }
  }

  void toggleMenu() {
    if (_programMenuSelected.value) {
      cardKey.currentState?.controller!.reverse();
    } else {
      cardKey.currentState?.controller!.forward();
    }
    _programMenuSelected.value = !_programMenuSelected.value;

    // update();
    // refresh(); // list 사용시 필요?
  }

  void _clear() {

  }

  void goHome() {
    programMenuHide();

    _currentPage = 'home';
    _webviewIndex = -1;
    _params = {};

    update();
  }

  void goDirect(String page) {
    programMenuHide();

    _currentPage = page;
    _webviewIndex = -1;
    _params = {};
    _anchor = '';

    update();
  }

  void webView(String page, {Map<String, dynamic>? param, String? anchor}) {
    programMenuHide();

    int index = -1;
    _params = param ?? {};
    _anchor = anchor ?? '';

    index = ConstWebPageList().getIndex(page); 
    

    _currentPage = 'webview';
    _webviewIndex = index;
    log('page: $page');
    update(); //필요
  }

  void programMenuHide() {
    if (programMenuSelected) {
      _programMenuSelected.value = !_programMenuSelected.value;
      cardKey.currentState?.controller!.reverse();
    }
  }


  void addNavItem({
    required bool active,
    required Widget icon,
    required Function touched,
    String? text,
    TextStyle? textStyle,
    EdgeInsets? iconPadding,
    Color? backgroundColor,
  }) {
    final navItem = NavItem(
      active: active,
      icon: icon,
      touched: touched,
      text: text,
      textStyle: textStyle,
      iconPadding: iconPadding,
      backgroundColor: backgroundColor,
    );

    _navItems.add(navItem);
  }

  Future<void> setMenu() async {
    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 11.0,
    );

    final AppService appService = AppService.to;
    await appService.initEzvSetting();

    EzvColor ezvColors = appService.getColor;

    addNavItem(
      icon: Image.asset(
        'assets/images/icons/bottomIcon01@2x.png',
        width: 20,
      ),
      iconPadding: const EdgeInsets.only(top: 5.0),
      text: 'HOME',
      textStyle: textStyle,
      touched: () {
        goHome();
      },
      active: false,
    );

    addNavItem(
      icon: FlipCard(
        key: NavItemController.cardKey,
        flipOnTouch: false,
        side: CardSide.FRONT,
        front: Container(
          // color: constDefultFooterBgColor ?? Color(int.parse('0xFF${colors['menuBgOn']??''}')),
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 100),
                    child: Image.asset(
                      'assets/images/icons/bottomIcon02@2x.png',
                      width: 20,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'PROGRAM',
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
        back: Container(
          color: const Color.fromRGBO(56, 71, 127, 1),
          child: Center(
            child: Image.asset(
              'assets/images/icons/x@2x.png',
              width: 20,
            ),
          ),
        ),
      ),
      touched: () {
        toggleMenu();
      },
      active: false,
    );

    addNavItem(
      icon: Image.asset(
        'assets/images/icons/nowCopy@2x.png',
        height: 50,
      ),
      iconPadding: const EdgeInsets.only(top: 3.0),
      textStyle: textStyle,
      touched: () {
        webView('now');
      },
      active: false,
    );

    addNavItem(
      icon: Image.asset(
        'assets/images/icons/bottomIcon04@2x.png',
        width: 20,
      ),
      iconPadding: const EdgeInsets.only(top: 5.0),
      text: 'SEARCH',
      textStyle: textStyle,
      touched: () {
        webView('search');
      },
      active: false,
    );

    addNavItem(
      icon: Image.asset(
        'assets/images/icons/bottomIcon05@2x.png',
        // width: 30,
        fit: BoxFit.contain,
        height: 20,
      ),
      iconPadding: const EdgeInsets.only(top: 5.0),
      text: 'FAVORITE',
      textStyle: textStyle,
      touched: () {
        webView('favorite');
        // Get.to(() => Page3());
      },
      active: false,
    );
  }
}