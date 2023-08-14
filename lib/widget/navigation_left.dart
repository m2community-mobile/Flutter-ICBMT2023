import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icbmt2023/page/voting.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../controller/nav_item_controller.dart';
import '../func_widget/make_left_navigation_cell.dart';
import '../page/booth_intro.dart';
import '../page/home.dart';

class NevLeftWidget extends StatelessWidget {
  NevLeftWidget({super.key});

  final double closeBtnWidth = 60.0; //닫기 버튼 영역 너비
  final double topBox1Height = 70.0;
  // final double topBox2Height = 60.0;
  final double topBox2Height = 0;

  final homeKey = Home.homeKey;    
  final navController = NavItemController.to;

  @override
  Widget build(BuildContext context) {

    
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            // 닫기버튼
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  homeKey.currentState!.openEndDrawer();
                },
                child: Container(
                  alignment: Alignment.topCenter,
                  color: Colors.transparent,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  width: closeBtnWidth,
                  height: MediaQuery.of(context).size.height,
                  child: const SizedBox(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
            ),
         
            topBox(context),
            navBox(context),
            
          ],
        ),
      ),
    );
  }


  Widget navBox(BuildContext context) {
    const TextStyle textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(38, 55, 119, 1), letterSpacing: -1);

    return Container(
      padding: EdgeInsets.only(
        top: (MediaQuery.of(context).padding.top + topBox1Height + topBox2Height),
      ),
      child: SingleChildScrollView(
        
        physics: const ClampingScrollPhysics(), 
        child: Container(
          padding: const EdgeInsets.only(bottom: 40),
          width: (MediaQuery.of(context).size.width - closeBtnWidth),
          child: ExpansionTileGroup(
            toggleType: ToggleType.expandOnlyCurrent, 
            children: [
              //1
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic1@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),
                title: const Text("ICBMT 2023", textScaleFactor: 1.0, style: textStyle,),
                menuExpanded: navController.isCurrentMenuOpen('1'),
                subMenus: [
                  ConstMenuLink(
                    title: 'Welcome Message',
                    touched: () {
                      movePage('welcome');
                    },
                  ),
                  ConstMenuLink(
                    title: 'Overview',
                    touched: () {
                      movePage('overview');
                    },
                  ),
                  ConstMenuLink(
                    title: 'Committee',
                    touched: () {
                      movePage('committee');
                    },
                  ),
                  ConstMenuLink(
                    title: 'Past ICBMT',
                    touched: () {
                      movePage('past');
                    },
                  ),
                ],
                touched: () {},
              ).build(),

              //2
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic2@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),
                title: const Text("About Venue", textScaleFactor: 1.0, style: textStyle,),
                menuExpanded: navController.isCurrentMenuOpen('2'),
                subMenus: [
                  ConstMenuLink(
                    title: 'About Venue',
                    touched: () {
                      movePage('venue');
                    },
                  ),
                  ConstMenuLink(
                    title: 'Transportation',
                    touched: () {
                      movePage('transportation');
                    },
                  ),
                  ConstMenuLink(
                    title: 'Floor Plan',
                    touched: () {
                      movePage('floor');
                    },
                  ),
                ],
                touched: () {},
              ).build(),

              //3
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic3@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),
                title: const Text("Program", textScaleFactor: 1.0, style: textStyle,),
                menuExpanded: navController.isCurrentMenuOpen('3'),
                subMenus: [
                  ConstMenuLink(
                    title: 'Program at a glance',
                    touched: () {
                      Home.homeKey.currentState!.openEndDrawer();
                      navController.goDirect('glance');
                    },
                  ),
                  for (var event in eventDays) ...[
                    ConstMenuLink(
                      title: event.titie,
                      touched: () {
                        // movePage(ConstWebpage(title: 'program', url: '${constWebPages[5].url}&tab=${dayName['index']}' ) );
                        movePage('program_day${event.day}');
                      },
                    ),
                  ],
                  ConstMenuLink(
                    title: 'My Schedule',
                    touched: () {
                      movePage('favorite');
                    },
                  ),
                  ConstMenuLink(
                    title: 'Now',
                    touched: () {
                      movePage('now');
                    },
                  ),
                ],
                touched: () {},
              ).build(),

              //4
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic4@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),                        
                title: const Text("Abstract", textScaleFactor: 1.0, style: textStyle,),
                touched: () {
                  movePage('abstract');
                },
              ).build(),

              //5
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic5@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),                        
                title: const Text("Invited Speakers", textScaleFactor: 1.0, style: textStyle,),
                touched: () {
                  movePage('faculty');
                },
              ).build(),

              //6
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic6@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),                        
                title: const Text("Voting", textScaleFactor: 1.0, style: textStyle,),
                touched: () {                  
                  // homeKey.currentState?.openEndDrawer();
                  // Get.toNamed(VotingWidget.routeName);
                  browserLaunch('https://icbmt2023.jlb.kr/vote.asp');
                },
              ).build(),

              //7
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic7@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),                        
                title: const Text("Sponsor", textScaleFactor: 1.0, style: textStyle,),
                menuExpanded: navController.isCurrentMenuOpen('7'),
                touched: () {
                  // movePage('sponsor');
                },
                subMenus: [
                  ConstMenuLink(
                    title: 'Sponsor',
                    touched: () {
                      movePage('sponsor');
                    },
                  ),
                  ConstMenuLink(
                    title: 'Exhibition Floor Plan',
                    touched: () {
                      movePage('exhibition');
                      // homeKey.currentState?.openEndDrawer();
                      // browserLaunch('http://ezv.kr/icbmt2023/html/contents/exhibition.html');

                    },
                  ),
                ],
              ).build(),

              //8
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic8@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),                        
                title: const Text("Survey", textScaleFactor: 1.0, style: textStyle,),
                touched: () {
                  movePage('survey');
                },
              ).build(),

              //9
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic9@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),                        
                title: const Text("Photo Gallery", textScaleFactor: 1.0, style: textStyle,),
                touched: () {
                  // movePage('notice');
                  homeKey.currentState?.openEndDrawer();
                  navController.goDirect('photo_list');
                  
                },
              ).build(),

              //10
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic10@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),                        
                title: const Text("Daily Newsletter", textScaleFactor: 1.0, style: textStyle,),
                touched: () async {
                  // movePage('newsletter');
                  browserLaunch('https://pxpro.org/email/ICBMT2023/news-letter-today.html');
                },
              ).build(),

              //11
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic11@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),                        
                title: const Text("Booth Stamp Event", textScaleFactor: 1.0, style: textStyle,),
                touched: () {
                  // movePage('abstract');
                  homeKey.currentState?.openEndDrawer();
                  Get.toNamed(BoothIntro.routeName);
                },
              ).build(),

              //12
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic12@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),                        
                title: const Text("Notice", textScaleFactor: 1.0, style: textStyle,),
                touched: () {
                  movePage('notice');
                },
              ).build(),

              //13
              MakeLeftNavigationCell(
                leading: Image.asset(
                  'assets/images/icons/ic13@2x.png',
                  fit: BoxFit.contain,
                  width: 38,
                ),                        
                title: const Text("My Schedule", textScaleFactor: 1.0, style: textStyle,),
                touched: () {
                  movePage('favorite');
                },
              ).build(),

            ],
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


  void movePage(String page) {
    homeKey.currentState?.openEndDrawer();
    navController.webView(page);
  }

  Widget topBox(BuildContext context) {
    return Container(
      color: Colors.white,
      width: (MediaQuery.of(context).size.width - closeBtnWidth),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).padding.top,
            child: Container(color: leftNavBackgoundColor),
          ),

          SizedBox(
            width: double.infinity,
            height: topBox1Height,
            child: Container(
              color: leftNavBackgoundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Home.homeKey.currentState!.openEndDrawer();
                      navController.goHome();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: Image.asset(
                          'assets/images/icons/icoTopHome@2x.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      Home.homeKey.currentState!.openEndDrawer();                      
                      navController.goDirect('setting');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Center(
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/icons/icoTopSettings@2x.png',
                              fit: BoxFit.contain,
                              width: 25,
                            ),
                            const SizedBox(width: 10,),
                            const Text(
                              'Setting',
                              textScaleFactor: 1.0,
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // SizedBox(
          //   height: topBox2Height,
          //   child: Container(
          //     color: const Color.fromRGBO(76, 99, 134, 1),
          //   ),
          // ),
        ],
      ),
    );
  }
}