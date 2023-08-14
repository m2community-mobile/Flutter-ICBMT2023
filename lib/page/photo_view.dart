import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants.dart';
import '../controller/ezv_item_controller.dart';
import '../controller/nav_item_controller.dart';
import '../controller/photo_controller.dart';
import '../data/ezv_item.dart';
import '../data/photo.dart';


import '../func_widget/permission_check.dart';
import '../service/app_service.dart';

class Photoview extends StatefulWidget {
  static String routeName = "/photo/view";
  Photoview({super.key});

  @override
  State<Photoview> createState() => _PhotoviewState();
}

class _PhotoviewState extends State<Photoview> {
  // int idx = 0;
  int photoIndex = 0;
  late var _tab;
  late PageController pageController;
  late PhotoController _photoController;
  
  final AppService _appService = AppService.to;


  void init() {
    photoIndex = Get.arguments['index'];
    _tab = Get.arguments['tab'];

    pageController = PageController(initialPage: photoIndex);
    _photoController = Get.put(PhotoController(_tab.toString()));
  }

  @override
  void initState() {
    super.initState();

    print("Photoview: initState()");
    init();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    print("Photoview: didChangeDependencies()");
    // init();
  }

  @override
  void dispose() {
    super.dispose();
    
    //닫을때 갱신
    _photoController.listReload();
    print("Photoview: dispose()");
  }

  @override
  Widget build(BuildContext context) {
    RxList<Photo> photos = _photoController.photos;
    double paddingTop = MediaQuery.of(context).padding.top;

    EzvColor ezvColors = _appService.getColor;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: paddingTop + 50,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                color: constDefultHeaderBgColor ?? ezvColors.menuBgOn,
                
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Text(
                      '${photoIndex + 1}/${photos.length}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(top: paddingTop + 10, right: 10),
                          child: Image.asset(
                              'assets/images/common/btnClosed@2x.png'),
                        ),
                        // child: Padding(
                        //   padding:
                        //       EdgeInsets.only(top: paddingTop, right: 10),
                        //   child: const Icon(
                        //     Icons.close,
                        //     color: Colors.white,
                        //     size: 50,
                        //   ),
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  PhotoViewGallery.builder(
                    itemCount: photos.length,
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider:
                            NetworkImage(constUrlPhotoFile + photos[index].url),
                        // initialScale: PhotoViewComputedScale.contained * 0.8,
                        minScale: PhotoViewComputedScale.contained,
                        filterQuality: FilterQuality.medium,
                      );
                    },
                    backgroundDecoration:
                        const BoxDecoration(color: Colors.white),
                    onPageChanged: (index) {
                      setState(() {
                        photoIndex = index;
                      });
                    },
                    pageController: pageController,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Container(
                        color: constDefultHeaderBgColor ?? ezvColors.menuBgOn.withAlpha(220),
                        width: 40,
                        height: 80,
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        pageController.nextPage(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeIn);
                      },
                      child: Container(
                        color: constDefultHeaderBgColor ?? ezvColors.menuBgOn.withAlpha(220),
                        width: 40,
                        height: 80,
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(photos[photoIndex].title ?? ''),
                  Row(
                    children: [
                      Obx(
                        () => TextButton.icon(
                          icon: photos[photoIndex].myfav == 0
                              ? const Icon(
                                  Icons.favorite_border,
                                  color: Color.fromRGBO(137, 137, 137, 1),
                                  size: 20,
                                )
                              : const Icon(Icons.favorite,
                                  color: Color.fromRGBO(237, 20, 91, 1),
                                  size: 20),
                          label: Text('${photos[photoIndex].cnt} Like'),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                      side: BorderSide(
                                          color: Color.fromRGBO(
                                              220, 220, 220, 1))))),
                          onPressed: () {
                            _photoController.favFetch(photoIndex, photos[photoIndex].myfav);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          // Map<Permission, PermissionStatus> statuses = await [
                          //   Permission.storage,
                          // ].request();

                          // // final info = statuses[Permission.storage].toString();
                          // // print(info);

                          // if (await Permission.storage.request().isGranted) {
                          //   var appDocDir = await getTemporaryDirectory();
                          //   String savePath = appDocDir.path + "${photos[photoIndex].url}";

                          //   await Dio().download("$constUrlPhotoFile${photos[photoIndex].url}", savePath);
                          //   final result = await ImageGallerySaver.saveFile(savePath);
                          //   print(result);

                          //   if (result['isSuccess'] == true) {
                          //     if(mounted) {
                          //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(constMessagePhotoDownComplete),
                              
                          //     ),);
                          //     }
                          //   }
                          // }

                          final PermissionResult = await PermissionCheck().request(context, Permission.photos);
                          if(PermissionResult) {
                            var appDocDir = await getTemporaryDirectory();
                            String savePath = "${appDocDir.path}${photos[photoIndex].url}";

                            await Dio().download("$constUrlPhotoFile${photos[photoIndex].url}", savePath);
                            final result = await ImageGallerySaver.saveFile(savePath);
                            debugPrint(result.toString());

                            if (result['isSuccess'] == true) {
                              if(mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(constMessagePhotoDownComplete),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        icon: const Icon(
                          Icons.save_alt,
                          color: Color.fromRGBO(137, 137, 137, 1),
                          size: 20,
                        ),
                        label: const Text('Save'),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side: BorderSide(
                                        color: Color.fromRGBO(
                                            220, 220, 220, 1))))),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      if (photos[photoIndex].deviceid ==
                          _appService.deviceId) ...[
                        TextButton.icon(
                          onPressed: () async {
                            
                            Get.dialog(
                              AlertDialog(
                                shape: constDialogShape,
                                title: constDialogPhotoDeleteTitle,
                                content: constDialogmPhotoDelete,
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _photoController.destroy(photoIndex);
                                      navigator?.pop();
                                      Get.back();
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Color.fromRGBO(137, 137, 137, 1),
                            size: 20,
                          ),
                          label: const Text('Delete'),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide(
                                  color: Color.fromRGBO(220, 220, 220, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
