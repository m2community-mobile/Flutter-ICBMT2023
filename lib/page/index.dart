import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../page/voting.dart';
import '../constants.dart';
import '../controller/nav_item_controller.dart';
import '../func_widget/make_center_navigation_cell.dart';
import '../widget/main_booth_icon.dart';
import 'booth_intro.dart';
import 'home.dart';

class NoticeItem {
  String sid;
  String subject;

  NoticeItem(this.sid, this.subject);
}

class IndexPage extends StatefulWidget {
  IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _navController = NavItemController.to;

  Future<NoticeItem> getNotice() async {
    final dio = Dio();
    final response = await dio.get(constUrlNoticeList);
    final result = jsonDecode(response.toString());

    if (result != null) {
      NoticeItem noticeItem =
          NoticeItem(result[0]['sid'], result[0]['subject']);
      return noticeItem;
    }

    return NoticeItem('', '');
  }

  @override
  Widget build(BuildContext context) {
    // print('b ${widget._noticeItems}');

    const double backGroundImageDownHeight = 35;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromRGBO(28, 7, 111, 1),
          ),
          Container(
            transform:
                Matrix4.translationValues(0, backGroundImageDownHeight, 0),
            decoration: BoxDecoration(
              //백그라운드 이미지
              image: DecorationImage(
                alignment: Alignment.bottomCenter,
                image: const AssetImage(
                  'assets/images/background/intro_bg@2x.png',
                ),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.75), BlendMode.dstATop),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                // Expanded(
                //   flex: 2,
                //   child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: GestureDetector(
                //       behavior: HitTestBehavior.translucent,
                //       // 좌상단 햄버거 버튼
                //       onTap: () {
                //         Home.homeKey.currentState!.openDrawer();
                //       },
                //       child: Padding(
                //         padding: const EdgeInsets.only(left: 20.0),
                //         // padding: const EdgeInsets.all(20.0),
                //         child: Image.asset(
                //           'assets/images/icons/home_hamburger_btn@2x.png',
                //           width: 30,
                //         ),
                //         // child: Placeholder(),
                //       ),
                //     ),
                //   ),
                // ),
                const Expanded(
                  flex: 2,
                  child: SizedBox.shrink(),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    width: double.infinity,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/images/background/home_top_text01@2x.png',
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                        Image.asset(
                          'assets/images/background/home_top_text02@2x.png',
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.50,
                        ),
                        Image.asset(
                          'assets/images/background/home_top_text03@2x.png',
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.width * 0.50,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      // color: Colors.yellow.withAlpha(150),
                      child: Column(
                        children: [
                          Expanded(child: centerRow1()),
                          Expanded(child: centerRow2()),
                          Expanded(child: centerRow3()),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  color: const Color.fromRGBO(76, 99, 134, 1),
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(179, 52, 110, 1),
                                shape: BoxShape.circle,
                              ),
                              child: const Text(
                                'N',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            const Text(
                              'Notice',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder(
                          future: getNotice(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const SizedBox.shrink();
                            } else {
                              NoticeItem noticeItem = snapshot.data;
                              
                              return noticeItem.sid.isEmpty ? 
                              const SizedBox.shrink()
                              : GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  // print("clicked : ${noticeItem.sid}");
                                  _navController.webView('notice_view',
                                      param: {'sid': noticeItem.sid});
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: double.infinity,
                                  child: Text(
                                    noticeItem.subject,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textScaleFactor: 1.0,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                // child: Placeholder(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
           Positioned(
                    left: 00,
                    top: MediaQuery.of(context).padding.top,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      // 좌상단 햄버거 버튼
                      onTap: () {
                        Home.homeKey.currentState!.openDrawer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'assets/images/icons/home_hamburger_btn@2x.png',
                          width: 30,
                        ),
                      ),
                    ),
                  ),
          Positioned(
            right: 0,
            top: MediaQuery.of(context).padding.top + MediaQuery.of(context).size.height * 0.18,
            child: GestureDetector(
              onTap: () {
                Get.toNamed(BoothIntro.routeName);
              },
              child: Container(
                // transform:
                //     Matrix4.translationValues(0, backGroundImageDownHeight, 0),
                // padding: const EdgeInsets.only(top: 5, bottom: 5),
                padding: const EdgeInsets.all(3.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                ),
                width: MediaQuery.of(context).size.height * 0.095,
                height: MediaQuery.of(context).size.height * 0.090,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text((MediaQuery.of(context).size.height * 0.0128).toStringAsFixed(2).toString()),
                    Padding(
                      padding: const EdgeInsets.only(left:5.0),
                      // child: Image.asset('assets/images/icons/homeIconBooth@2x.png', 
                      //   fit: BoxFit.contain,
                      //   height: double.parse((MediaQuery.of(context).size.height * 0.04).toStringAsFixed(2)),
                      // ),
                      child: MainBoothIcon(double.parse((MediaQuery.of(context).size.height * 0.04).toStringAsFixed(2))),
                    ),
                    Text('Booth\nStamp Event', 
                      textAlign: TextAlign.center, 
                      textScaleFactor: 1.0,
                      style: TextStyle(                      
                        color: const Color.fromRGBO(40, 63, 173, 1),
                        fontSize: double.parse((MediaQuery.of(context).size.height * 0.0128).toStringAsFixed(2))
                      ),
                    ),

                    // AutoSizeText('Booth\nStamp Event',
                    //   maxLines: 2,
                    //   textScaleFactor: 1.0,
                    //   textAlign: TextAlign.center, style: TextStyle(
                    //   color: const Color.fromRGBO(40, 63, 173, 1),
                    //   fontSize: double.parse((MediaQuery.of(context).size.height * 0.0128).toStringAsFixed(2))
                    // ),),
                    
                    
                  ]
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> browserLaunch(url) async {
    final Uri linkUrl = Uri.parse(url);

    if (!await launchUrl(linkUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $linkUrl');
    }
  }

  Row centerRow1() => Row(
        children: [
          Expanded(
            child: MakeCenterCell(
              touched: () {
                _navController.webView('welcome');
              },
              text: 'ICBMT 2023',
              icon: Image.asset('assets/images/icons/homeIcon1@2x.png'),
            ),
          ),
          Expanded(
            child: MakeCenterCell(
              touched: () {
                _navController.webView('program');
              },
              text: 'Program',
              icon: Image.asset('assets/images/icons/homeIcon2@2x.png'),
            ),
          ),
          Expanded(
            child: MakeCenterCell(
              touched: () {
                _navController.webView('abstract');
              },
              text: 'Abstract',
              icon: Image.asset('assets/images/icons/homeIcon3@2x.png'),
            ),
          ),
        ],
      );

  Row centerRow2() => Row(
        children: [
          Expanded(
            child: MakeCenterCell(
              touched: () {
                _navController.webView('faculty');
              },
              text: 'Invited Speakers',
              icon: Image.asset('assets/images/icons/homeIcon4@2x.png'),
            ),
          ),
          Expanded(
            child: MakeCenterCell(
              touched: () {
                // Get.toNamed(VotingWidget.routeName);
                browserLaunch('https://icbmt2023.jlb.kr/vote.asp');
              },
              text: 'Voting',
              icon: Image.asset('assets/images/icons/homeIcon5@2x.png'),
            ),
          ),
          Expanded(
            child: MakeCenterCell(
              touched: () {
                _navController.goDirect('photo_list');
              },
              text: 'Photo Gallery',
              icon: Image.asset('assets/images/icons/homeIcon6@2x.png'),
            ),
          ),
        ],
      );

  Row centerRow3() => Row(
        children: [
          Expanded(
            child: MakeCenterCell(
              touched: () {
                _navController.webView('survey');
              },
              text: 'Survey',
              icon: Image.asset('assets/images/icons/homeIcon7@2x.png'),
            ),
          ),
          Expanded(
            child: MakeCenterCell(
              touched: () async {
                // _navController.webView('newsletter');
                browserLaunch('https://pxpro.org/email/ICBMT2023/news-letter-today.html');
              },
              text: 'Daily Newletter',
              icon: Image.asset('assets/images/icons/homeIcon8@2x.png'),
            ),
          ),
          Expanded(
            child: MakeCenterCell(
              touched: () {
                _navController.webView('sponsor');
              },
              text: 'Sponsors',
              icon: Image.asset('assets/images/icons/homeIcon9@2x.png'),
            ),
          ),
        ],
      );
}
