import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AutoScroll extends StatefulWidget {
  final double height;
  final List<Widget> items;

  AutoScroll({super.key, this.height = 24.0, required this.items});
  @override
  State<StatefulWidget> createState() => _AutoScrollState();
}

class _AutoScrollState extends State<AutoScroll>
    with SingleTickerProviderStateMixin {
  ScrollController scrollCtrl = ScrollController();
  late AnimationController _animationController;
  late PageController _PageController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  initState() {
    // double offset = 0.0;
    // double offset = 250;
    super.initState();
    // animateCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))
    //       ..addListener(() {
    //         // print(offset);
    //         if (animateCtrl.isCompleted) animateCtrl.repeat();
    //         offset += 1.0;
    //         if (offset - 1 > scrollCtrl.offset) {
    //           offset = 0.0;
    //           // Fluttertoast.showToast(msg: 'offset');
    //           // print(scrollCtrl.offset);
    //         }
    //         setState(() {
    //           scrollCtrl.jumpTo(offset);
    //         });
    //       });
    // animateCtrl.forward();

    
    _PageController = PageController(
      viewportFraction: 1 / 3,
        initialPage: 0,
    );

    // _PageController.addListener(() {
      
        // _PageController.animateTo(_PageController.offset+10, duration: Duration(milliseconds: 100), curve: Curves.ease);
      
    // });

    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));

    _animationController.addListener(() {
      if (_animationController.isCompleted) _animationController.repeat();
      _PageController.animateTo(_PageController.offset+10, duration: const Duration(milliseconds: 150), curve: Curves.ease);
    });

    _animationController.forward();

    

    

    // var animateCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 1));

    // Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
    //   offset = offset+10;

    //   _PageController.animateTo(offset, duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
    //   print(offset);
      
    //   // _PageController.animateToPage(
    //   //   currentPage,
    //   //   duration: Duration(milliseconds: 350),
    //   //   curve: Curves.easeIn,
    //   // );
    // });
  }

  @override
  Widget build(BuildContext context) {

    // WidgetsBinding.instance.addPostFrameCallback((_) => _PageController.animateTo(_PageController.offset+10, duration: Duration(milliseconds: 100), curve: Curves.ease));

    return Container(
      height: widget.height,
      // padding: EdgeInsets.all(4.0),
      child: Center(
        // child: ListView(
        //   controller: scrollCtrl,
        //   scrollDirection: Axis.horizontal,
        //   children: widget.items,
        // ),

        // child: ListView.builder(
        //   controller: scrollCtrl,
        //   scrollDirection: Axis.horizontal,
        //   itemCount: widget.items.length,
        //   itemBuilder: (buildContext, index) {
        //     // return widget.items[index % widget.items.length];
        //     return widget.items[index];
        //   },
        // ),
        child: PageView.builder(
          // physics:ClampingScrollPhysics(),
          // physics:ClampingScrollPhysics(),
          pageSnapping: false,
          scrollDirection: Axis.horizontal,
          // controller: PageController(viewportFraction: 1 / 3),
          controller: _PageController,

          itemBuilder: (buildContext, index) {
            return widget.items[index % widget.items.length];
            // return widget.items[index];
          },
          
        ),
     

        
        // child: Row(children: [

        //   for(var item in widget.items)
        //           ... [ item, ]
        // ]),
      ),
    );
  }
}