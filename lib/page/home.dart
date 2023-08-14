import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../func_widget/auto_scroll2.dart';
import '../func_widget/auto_scroll3.dart';
import '../func_widget/auto_scroll4.dart';
import '../service/app_service.dart';
import '../controller/notification_controller.dart';
import '../data/ezv_item.dart';

import '../constants.dart';
import '../controller/nav_item_controller.dart';
import '../func_widget/make_bottom_navigation.dart';
import '../widget/navigation_left.dart';
import '../widget/navigation_program.dart';

class Home extends StatelessWidget {
  
  static String routeName = "/main";
  static final GlobalKey<ScaffoldState> homeKey = GlobalKey(); 

  NotificationController? notificationController;

  Home({super.key, this.notificationController});
  
  final appService = AppService.to;
  final navController = NavItemController.to;

  @override
  Widget build(BuildContext context) {
    // 가로모드 방지
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // 가로모드 방지

    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild());

    EzvColor ezvColors = appService.getColor;

    if(navController.isInitialized == false) {
      navController.init();
    }

  
    
    return WillPopScope(
      onWillPop: () async { //뒤로가기 클릭시 체크
      
        String page = navController.currentPage;       
        log('homm currentPage: $page');
            
        if (page == 'webview' || page == 'home') {
          return true;
        } else {
          navController.goHome();
          return false;
        }        
      },
      child: Scaffold(
        key: homeKey,
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Colors.transparent, //drawer 배경 투명
            // dividerColor: Colors.transparent, //나중에 쓸일 있을까?
          ),
          child: Drawer(
            width: MediaQuery.of(context).size.width,
            // child: NevLeftWidget(),
            child: GetBuilder<NavItemController>(
              builder: (_) => NevLeftWidget()
            ),
          ),
        ),

        body: GetBuilder<NavItemController>(
          builder: (_) => Container(
            child: Stack(
              children: [

                _getPage(context),

                GestureDetector(
                  onTap: () {
                    navController.toggleMenu();
                  },

                  child: Obx(() => navController.programMenuSelected ? 
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.white.withOpacity(0),
                    ) 
                    : const SizedBox.shrink()
                  ),
                ),
                Obx(() => navController.programMenuSelected ? 
                Positioned(
                    bottom: 0,
                    left: MediaQuery.of(context).size.width * 0.1,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.60,
                            height: 180,
                            child: const NavProgram(),
                          ),
                        ),
                        Row(
                          children: [
                            ClipPath(
                              clipper: CustomClipPath(),
                              child: Container(
                                padding: const EdgeInsets.only(left: 30),
                                height: 10,
                                width: 15,
                                color: const Color.fromRGBO(23, 29, 71, 1),
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.2,)
                          ],
                        )
                      ],
                    ),
                  )
                : const SizedBox.shrink()
                
                ),
              ],
            ),
          ),
        ),

        // bottomNavigationBar: GetBuilder<NavItemController>(
        //   builder: (_) => 
        //     (['setting', 'booth_list'].contains(navController.currentPage)) ? // footer navigation 안보이게
        //     const SizedBox.shrink() :
        //     MakeBottomNavigation(
        //       height: constBottomNaviHeight,
        //       marginBottom: MediaQuery.of(context).padding.bottom,
        //       // color: ezvColors.menuBgOn,
        //       color: const Color.fromRGBO(23, 29, 71, 1), 
        //       children: navController.navItems,
        //     ),
        // ),

        // bottomNavigationBar: SizedBox(
        //   height: constBottomNaviHeight + 50 + MediaQuery.of(context).padding.bottom,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       MakeBottomNavigation(
        //         height: constBottomNaviHeight,
        //         // marginBottom: MediaQuery.of(context).padding.bottom,
        //         // color: ezvColors.menuBgOn,
        //         color: const Color.fromRGBO(23, 29, 71, 1), 
        //         children: navController.navItems,
        //         // children: [],
        //       ),
        //       Container(
        //         height: 50,
        //         color: Colors.yellow,
        //         margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        //         child: Placeholder()
        //       )
        //     ],
        //   ),
        // ),

        bottomNavigationBar: GetBuilder<NavItemController>(
          builder: (_) => 
            (['setting', 'booth_list'].contains(navController.currentPage)) ? // footer navigation 안보이게
            const SizedBox.shrink()
            : SizedBox(
            // height: constBottomNaviHeight + 50 + MediaQuery.of(context).padding.bottom,
            height: constBottomNaviHeight + MediaQuery.of(context).padding.bottom + (['home'].contains(navController.currentPage) ? 50 : 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MakeBottomNavigation(
                  height: constBottomNaviHeight,
                  marginBottom: ['home'].contains(navController.currentPage) ? 0 : MediaQuery.of(context).padding.bottom,
                  // color: ezvColors.menuBgOn,
                  color: const Color.fromRGBO(23, 29, 71, 1), 
                  children: navController.navItems,
                ),
                (['home'].contains(navController.currentPage)) ? Container(
                  height: 50,
                  // color: Colors.yellow,
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                  // child: Placeholder()
                  child: Container(
                    // height: 80,
                    color: Colors.white,
                    // child: AutoScroll(items: [
                    //   for(var list in bannerLists)
                    //   ... [ 
                    //     GestureDetector(
                    //       onTap: () {
                    //         browserLaunch(list['linkurl']);
                    //         print(list['linkurl']);
                    //       },
                    //       child: Image.network(list['image']!), 
                    //     ),
                        
                    //   ]
                    // ]),

                    // child: AutoScroll2(),
                    child: AutoScroll4(),
                  )
                ) : const SizedBox.shrink()
              ],
            ),
          ),
        ),

      ),
    );
  }

  Future<void> browserLaunch(url) async {
    final Uri linkUrl = Uri.parse(url);

    if (!await launchUrl(linkUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $linkUrl');
    }
  }

  void afterBuild() async {

    if(notificationController != null) {
      Timer(const Duration(milliseconds: 500), () {
        notificationController?.showDialog();
        notificationController = null;        
      });
    }
    
    if (await Permission.notification.request().isGranted) {
      appService.setTokenToServer();
    }
    // log('주석 풀어야함 : home.dart', name: '개발확인');
    // appService.setTokenToServer();
   

  }

  Widget _getPage(BuildContext context) {
    return navController.getWidget(context);
  }
  
}

class CustomClipPath extends CustomClipper<Path> {
  // var radius = 5.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}