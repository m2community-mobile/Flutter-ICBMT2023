import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class AutoScroll3 extends StatefulWidget {
  final double height;

  AutoScroll3({this.height = 24.0});
  @override
  State<StatefulWidget> createState() => new _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScroll3>
    with SingleTickerProviderStateMixin 
  {
  ScrollController scrollCtrl = ScrollController();
  // late AnimationController animateCtrl;

  List<Image> items = [];
  List items2 = [];

  @override
  void dispose() {
    // animateCtrl.dispose();
    super.dispose();
  }

  @override
  initState() {

    debugPrint('initState');

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

    items2 = bannerListData;
    
    for(var list in bannerListData) {
      // items.add(
      //   GestureDetector(
      //     onTap: () {
      //       print(list['linkurl']);
      //     },
      //     child: Image.network(list['image']!),
      //   )

      // );
      items.add(
        Image.network(list['image']!)
      );
    }

    double offset = 0.0;
    super.initState();
    // animateCtrl =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 3))
    //       ..addListener(() {
    //         if (animateCtrl.isCompleted) animateCtrl.repeat();
    //         offset += 1.0;
    //         // if (offset - 1 > scrollCtrl.offset) {
    //           // offset = 0.0;
    //         // }
    //         setState(() {
    //           scrollCtrl.jumpTo(offset);
    //         });
    //       });
    // animateCtrl.forward();
  }

  @override
  void didChangeDependencies() {
    debugPrint('didChangeDependencies');

    items.forEach((element) {
      // print(element.toString());
      // final image = element;

      precacheImage(element.image, context);
      // precacheImage(
      // Image.network(
      //         'https://terry1213.github.io/assets/flutter/Tip/precacheImage/network_image.JPG')
      //     .image,
      // context,
      // );

      
    });

    
    super.didChangeDependencies();
    
    
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    return Container(
      // width: 200.0,
      // color: Colors.blueGrey.shade800,
      height: widget.height,
      // padding: EdgeInsets.all(4.0),
      child: Center(
        // child: ListView(
        //   controller: scrollCtrl,
        //   children: items,
        //   scrollDirection: Axis.horizontal,
        // ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // controller: scrollCtrl,
          // itemCount: items.length,
          itemBuilder: (buildContext, index) {
            // return items[index]; //error

            final int = index % items.length;
            // return Text('$int');
            return GestureDetector(
              onTap: () {
                print("clicked");
              },
              // child: Image.network(items2[int]['image']!),
              // child: Container(child: Text('${items2[int]['image']!}')),
              child: items[0],
            );
          },
        ),
      ),
    );
  }
}