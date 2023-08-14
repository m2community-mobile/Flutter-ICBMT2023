import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/photo_controller.dart';
import '../constants.dart';
import '../controller/nav_item_controller.dart';
import '../page/photo_view.dart';
import '../data/photo.dart';
import '../func_widget/make_header.dart';
import 'home.dart';

class PhotoList extends StatefulWidget {
  // String tab;
  static String routeName = '/photo/list';

  // PhotoList({super.key, String? tab}) : tab = tab ?? "-1";
  // PhotoList({super.key, String? tab}) : tab = tab ?? "-1";

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  final navController = NavItemController.to;
  late PhotoController _photoController;
  
  // String tab = '-1';
  String tab = '462';

  @override
  void initState() {
    super.initState();
    print(tab);
    _photoController = Get.put(PhotoController(tab));

    print("PhotoList: initState()");
    print("PhotoList: tab = ${tab}");
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    _photoController.tabReset(tab);

    print("PhotoList: setState()");
    print("PhotoList: tab = ${tab}");
  }

  @override
  void dispose() {
    super.dispose();
    print("PhotoList: dispose()");

    
    Get.delete<PhotoController>();
  }


  @override
  void didUpdateWidget(covariant PhotoList oldWidget) {
    super.didUpdateWidget(oldWidget);


    print("PhotoList: didUpdateWidget()");
    print("PhotoList: didUpdateWidget() > oldWidget = ${tab}");
    print("PhotoList: didUpdateWidget() > widget.tab = ${tab}");

    // if(oldWidget.tab != widget.tab) {
    //   _photoController.tabReset(widget.tab);
    // }
  }



  @override
  Widget build(BuildContext context) {
    const double footerBtnHeight = 50;

    const Color inactiveFontColor = Color.fromRGBO(137, 137, 137, 1);
    const Color inactiveBorderColor = Color.fromRGBO(220, 220, 220, 1);
    const Color activeFontColor = Color.fromRGBO(48, 129, 224, 1);

    return Scaffold(
 
      appBar: AppHeader(navController: navController),

      body: Stack(
        children: [
          Column(
            children: [
              AppHeaderSub(navController: navController, title: 'Photo Gallery',),
              SizedBox(
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Expanded(
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       setState(() {
                    //         tab = '-1';
                    //       });
                    //     },
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         border: Border(
                    //           bottom: BorderSide(
                    //               width: 2.0,
                    //               color: tab == '-1'
                    //                   ? activeFontColor
                    //                   : inactiveBorderColor),
                    //         ),
                    //       ),
                    //       child: Center(
                    //         child: Text(
                    //           'Photogenic\nAward',
                    //           textAlign: TextAlign.center,
                    //           textScaleFactor: 1.0,
                    //           style: TextStyle(
                    //               fontSize: 13,
                    //               color: tab == '-1'
                    //                   ? activeFontColor
                    //                   : inactiveFontColor),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            tab = '462';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 2.0,
                                  color: tab == '462'
                                      ? activeFontColor
                                      : inactiveBorderColor),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'August 31\n(Thu)',
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: tab == '462'
                                      ? activeFontColor
                                      : inactiveFontColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            tab = '463';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 2.0,
                                  color: tab == '463'
                                      ? activeFontColor
                                      : inactiveBorderColor),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'September 1\n(Fri)',
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: tab == '463'
                                      ? activeFontColor
                                      : inactiveFontColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            tab = '464';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  width: 2.0,
                                  color: tab == '464'
                                      ? activeFontColor
                                      : inactiveBorderColor),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'September 2\n(Sat)',
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: tab == '464'
                                      ? activeFontColor
                                      : inactiveFontColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 90,
            ),
            child: Obx(
              () => (_photoController.isLoaded.value == false)
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: _photoController.photos.length,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 60),
                      physics: const ClampingScrollPhysics(), //bounce 방지
                      itemBuilder: (BuildContext context, int index) {
                        return WidgetPhotoItem(index);
                      },
                    ),
            ),
          ),
          // if (tab == "-1")
          //   Align(
          //     alignment: Alignment.bottomCenter,
          //     child: GestureDetector(
          //       onTap: () {
          //         Get.toNamed(PhotoUpload.routName);
          //       },
          //       child: Container(
          //         height: footerBtnHeight,
          //         width: double.infinity,
          //         color: Colors.blue,
          //         child: const Center(
          //           child: Text(
          //             "Photogenic Award 참여하기",
          //             textScaleFactor: 1.0,
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.w800,
          //               fontSize: 18,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget WidgetPhotoItem(int index) {
    Photo photo = _photoController.photos[index];

    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(220, 220, 220, 1),),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          FadeInImage(
            image: NetworkImage(constUrlPhotoFile + photo.url),
            fadeInDuration: const Duration(milliseconds: 300),
            placeholder: const AssetImage(
                "assets/images/background/home_top_text01@2x.png"),
            placeholderFit: BoxFit.scaleDown,
            imageErrorBuilder: (context, error, stackTrace) {
              return Image.asset(
                  'assets/images/background/home_top_text01@2x.png',
                  fit: BoxFit.contain);
            },
            fit: BoxFit.cover,
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(Photoview.routeName, arguments: {'index': index, 'tab': tab});
            },
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.65, 1],
                    colors: [Colors.transparent, Colors.black]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              margin: const EdgeInsets.all(5),
              child: GestureDetector(
                onTap: () {
                  _photoController.favFetch(index, photo.myfav);
                },
                child: Wrap(
                  spacing: 5,
                  children: [
                    if (photo.myfav == 0) ...[
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ] else ...[
                      const Icon(
                        Icons.favorite,
                        color: Color.fromRGBO(237, 20, 91, 1),
                        size: 20,
                      ),
                    ],
                    Text(
                      photo.cnt,
                      textScaleFactor: 1.0,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetPhotosList extends StatelessWidget {
  final List<Photo> photos;

  WidgetPhotosList({super.key, required this.photos});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: photos.length,
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 60),
      physics: const ClampingScrollPhysics(), //bounce 방지
      itemBuilder: (context, index) {
        var photo = photos[index];

        return Container(
          margin: const EdgeInsets.all(5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FadeInImage(
                image: NetworkImage(constUrlPhotoFile + photo.url),
                placeholder: const AssetImage(
                    "assets/images/background/photo_background_default@2x.png"),
                // placeholder: ResizeImage(const AssetImage("assets/images/background/photo_background_default@2x.png"), width: 30,),
                placeholderFit: BoxFit.scaleDown,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                      'assets/images/background/photo_background_default@2x.png',
                      fit: BoxFit.contain);
                },
                fit: BoxFit.cover,
              ),
              // Positioned(bottom: 0, child: SizedBox(height: 40, child: Container( color: Colors.red, child: Text('1234'),),),),
              // Container( color: Colors.red, child: SizedBox(height: 40, child: Text('123'),),),
              // SizedBox(height: 40, child: Placeholder(),),
              GestureDetector(
                onTap: () {
                  print("image");
                },
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.65, 1],
                        colors: [Colors.transparent, Colors.black]),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: GestureDetector(
                    onTap: () {
                      print("icon");
                    },
                    child: Wrap(
                      spacing: 5,
                      children: [
                        if (photo.myfav == 0) ...[
                          const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 20,
                          ),
                        ] else ...[
                          const Icon(
                            Icons.favorite,
                            color: Color.fromRGBO(237, 20, 91, 1),
                            size: 20,
                          ),
                        ],
                        Text(
                          photo.cnt,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
