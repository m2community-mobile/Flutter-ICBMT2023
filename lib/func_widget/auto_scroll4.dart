import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class AutoScroll4 extends StatefulWidget {
  final double height;

  AutoScroll4({this.height = 24.0});
  @override
  State<StatefulWidget> createState() => new _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScroll4>
    with SingleTickerProviderStateMixin {
  ScrollController scrollCtrl = ScrollController();
  late AnimationController animateCtrl;

  List<Widget> items = [];
  
  @override
  void dispose() {
    animateCtrl.dispose();
    debugPrint("animate dispose");
    super.dispose();
  }

  @override
  initState() {
    debugPrint('initState');

    double moveOffset;
    if(Platform.isAndroid) {
      moveOffset = 0.6;
    } else {
      moveOffset = 1.2;
    }

    

    double offset = 0.0;
    super.initState();
    animateCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..addListener(() {
            if (animateCtrl.isCompleted) animateCtrl.repeat();
            

            if(scrollCtrl.positions.isNotEmpty) {
              offset += moveOffset;
            //   if (offset - moveOffset > scrollCtrl.offset) {
            // offset = 0.0;
            // }
            if (offset - moveOffset > scrollCtrl.position.maxScrollExtent) {
              // print('a');
              offset = 0.0;
            }

            // setState(() {
              scrollCtrl.jumpTo(offset);
            // });


            }
            
          });
    animateCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   // color: Colors.blueGrey.shade800,
    //   height: widget.height,
    //   // padding: EdgeInsets.all(4.0),
    //   child: Center(

    //     child: ListView.builder(
    //       scrollDirection: Axis.horizontal,
    //       controller: scrollCtrl,
    //       itemCount: items.length * 2,
    //       itemBuilder: (buildContext, index) {
    //         return GestureDetector(onTap: () {
    //           print('clicked');
    //         }, child: items[index % items.length]);
    //       },
    //     ),
    //   ),
    // );

    return Container(
      height: widget.height,
      child: Center(
        child: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // if (snapshot.connectionState != ConnectionState.done) {
            if (snapshot.hasData == false || snapshot.data == null) {
              return const SizedBox.shrink();
            } else if (snapshot.hasError) {
              return const SizedBox.shrink();
            } else {              
              // print(items.length);
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: scrollCtrl,
                itemCount: snapshot.data.length * 10,
                itemBuilder: (buildContext, index) {
                  return snapshot.data[index % snapshot.data.length];
                }
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Widget>> getData() async {

    // var bannerListData = [
    //   {
    //     "sid": "1306",
    //     "linkurl": "https://www.kyowakirin.com/index.html",
    //     "image": "http://ezv.kr/voting/upload/booth/1659424089platinum_001.png"
    //   },
    //   {
    //     "sid": "1309",
    //     "linkurl": "https://www.sanofi.co.kr/",
    //     "image": "http://ezv.kr/voting/upload/booth/1659424099platinum_002.png"
    //   },
    //   {
    //     "sid": "1310",
    //     "linkurl": "https://www.janssen.com/korea/",
    //     "image": "http://ezv.kr/voting/upload/booth/1659424109platinum_003.png"
    //   },
    //   {
    //     "sid": "1311",
    //     "linkurl": "https://www.astellas.com/kr/ko",
    //     "image": "http://ezv.kr/voting/upload/booth/1659424121platinum_004.png"
    //   },
    // ];

    final dio = Dio();
    final response = await dio.get(constUrlSponsorList);
    final result = jsonDecode(response.toString());

    // print(result);
    print('getdata');

    List<Widget> bannerListData = [];
    for (var list in result) {
 
      bannerListData.add( GestureDetector( child: Image.network(list['image']!), onTap: () {
        browserLaunch(list['linkurl']);
      },));
    }
    return bannerListData;
  }

  Future<void> browserLaunch(url) async {
    final Uri linkUrl = Uri.parse(url);

    if (!await launchUrl(linkUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $linkUrl');
    }
  }
}
