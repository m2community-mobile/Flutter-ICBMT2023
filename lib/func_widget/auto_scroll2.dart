import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AutoScroll2 extends StatefulWidget {
  final double height;
  

  AutoScroll2({super.key, this.height = 24.0});
  @override
  State<StatefulWidget> createState() => _AutoScrollState();
}

class _AutoScrollState extends State<AutoScroll2> with SingleTickerProviderStateMixin {
  ScrollController scrollCtrl = ScrollController();
  late AnimationController _animationController;
  late PageController _pageController;
  late ScrollController _scrollController;

  late List<dynamic> items;

  @override
  void dispose() {
    // _animationController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    
    _pageController = PageController(
      viewportFraction: 1 / 3,
        initialPage: 0,
    );

    var bannerListData = [
      {
        "sid": "1306",
        "linkurl": "https://www.kyowakirin.com/index.html",
        "image":
            "http://ezv.kr/voting/upload/booth/1659424089platinum_001.png"
      },
      {
        "sid": "1309",
        "linkurl": "https://www.sanofi.co.kr/",
        "image":
            "http://ezv.kr/voting/upload/booth/1659424099platinum_002.png"
      },
      {
        "sid": "1310",
        "linkurl": "https://www.janssen.com/korea/",
        "image":
            "http://ezv.kr/voting/upload/booth/1659424109platinum_003.png"
      },
      {
        "sid": "1311",
        "linkurl": "https://www.astellas.com/kr/ko",
        "image":
            "http://ezv.kr/voting/upload/booth/1659424121platinum_004.png"
      },
    ];
    var bannerLists = [];
    for(var list in bannerListData) {
      bannerLists.add(Image.network(list['image']!));
    }

    items = bannerLists;

    // _scrollController = ScrollController();

    // _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1))
    // ..addListener(() {
      
    //   _pageController.animateTo(_pageController.offset+10, duration: const Duration(milliseconds: 150), curve: Curves.ease);
      
    //   if (_animationController.isCompleted) _animationController.repeat();
    // })
    // ..forward();

    

    // _scrollController = ScrollController();

  }

  @override
  Widget build(BuildContext context) {

    // WidgetsBinding.instance.addPostFrameCallback((_) => _PageController.animateTo(_PageController.offset+10, duration: Duration(milliseconds: 100), curve: Curves.ease));
    // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollController.animateTo(_scrollController.offset+3000, duration: const Duration(milliseconds: 15000), curve: Curves.easeIn));

    // return GestureDetector(
    //   onTapDown: (details) {
    //     // print('${details.globalPosition}');
    //     // _animationController.stop();
    //     // setState(() {
          
    //     // });
    //   },
    //   child: Container(
    //     height: widget.height,
    //     child: PageView.builder(
    //       physics: NeverScrollableScrollPhysics(),
    //       controller: _pageController,
    //       itemBuilder: (buildContext, index) {
    //         // return widget.items[index % widget.items.length];
    //         return GestureDetector(onTap:() { print('1'); }, child: items[index % items.length]);            
    //       },
    //     ),
    //   ),
    // );

    return CarouselSlider(
      options: CarouselOptions(height: 400.0, 
      viewportFraction: 1/3,
      scrollPhysics: NeverScrollableScrollPhysics(),
      autoPlayInterval : const Duration(seconds: 3),
      autoPlay: true,
      ),
      items: items.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              // margin: EdgeInsets.symmetric(horizontal: 5.0),              
              child: GestureDetector(onTap: () {
                print('clicked');
              }, child: i)
            );
          },
        );
      }).toList(),
    );



  }

  Future<void> browserLaunch(url) async {
    final Uri linkUrl = Uri.parse(url);

    if (!await launchUrl(linkUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $linkUrl');
    }
  }
}