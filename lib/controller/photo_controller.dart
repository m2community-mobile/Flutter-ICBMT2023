import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../data/photo.dart';

class PhotoController extends GetxController {

  final RxBool isLoaded = false.obs;
  RxString tab = "".obs;
  RxList<Photo> _photos = <Photo>[].obs;  

  // PhotoController(this.tab) {
  //   fetchPhotos();
  // }
  PhotoController(String tab) {
    this.tab.value = tab;
  }


  @override
  void onInit() async {
    super.onInit();

    print("PhotoController: onInit()");
    print("PhotoController: tab = $tab");
    fetchPhotos();
  }


  Future<void> fetchPhotos() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceid = prefs.getString('deviceid') ?? "";

    final dio = Dio();
    final response = await dio.get("$constUrlPhoto&tab=$tab&deviceid=$deviceid");

    isLoaded.value = true;
    // isLoaded = true;

    if(response.toString() == 'null') {
      return;
    }
    
    final parsed = json.decode(response.toString()).cast<Map<String, dynamic>>();
    _photos.value = parsed.map<Photo>((json) => Photo.fromJson(json)).toList();

    // _photos.refresh();
  }

  RxList<Photo> get photos => _photos;
  int get length => _photos.length;

  void tabReset(String tab) {
    isLoaded.value = false;
    
    this.tab.value = tab;
    fetchPhotos();
  }

  void listReload() {
    fetchPhotos();
  }


  void favFetch(int index, int myFav) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceid = prefs.getString('deviceid') ?? "";

    String sid = _photos[index].sid;
    int val = myFav == 0 ? 1 : 0;

    final dio = Dio();
    final response = await dio.get("$constUrlPhotoFavor&deviceid=$deviceid&val=$val&sid=$sid");
    
    String cnt = response.toString();

    _photos[index].cnt = cnt;
    _photos[index].myfav = val;    
    _photos.refresh();

  }

  void destroy(int index) async {
    
    String image = _photos[index].url;
    print(image);

    final dio = Dio();
    final response = await dio.get("$constUrlPhotoDelete&image=$image");

  }

}