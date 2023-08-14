import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../data/ezv_item.dart';

class EzvItemController extends GetxController {

  // static EzvItemController get to => Get.isRegistered<EzvItemController>() ? Get.find<EzvItemController>() : Get.put(EzvItemController());
  static EzvItemController get to => Get.isRegistered<EzvItemController>() ? Get.find<EzvItemController>() : Get.put(EzvItemController(), permanent: true);

  final _isInitialized = false.obs;
  final Rx<EzvItem> ezvItem = EzvItem().obs;


  bool get isInitialized => _isInitialized.value;
  get getColor => ezvItem.value.colors;
  String? get tab => ezvItem.value.tab;
  String? get mon => ezvItem.value.mon;
  String? get dayType => ezvItem.value.dayType;

  List<EzvDayItem> get getDay => ezvItem.value.day;

  // @override
  // void onInit() {
  //   // init();
  //   super.onInit();
  // }

  @override
  void onClose() {
    _isInitialized.value = false;
    super.onClose();
  }

  Future<void> init() async {
    if(_isInitialized.value == false) {
      await getSetting();
      _isInitialized.value = true;

      debugPrint('EzvItemController initialize!!');
    }
  }

  Future<void> getSetting() async {

    final dio = Dio();

    // ezv 정보를 가져와 셋팅    
    final responseGetSet = await dio.get(constUrlGetSet);
    final getSetData = jsonDecode(responseGetSet.toString());
    
    log(getSetData.toString(), name: 'EzvItemController');
    setData(getSetData);

  }

  void setData(Map data) {

    ezvItem.value = EzvItem(
      dayType: data['day_type'],
      tab: data['tab'],
      mon: data['mon'],
      
      // colors: {
      //   'menuBg': constDefultHeaderSubBgColor ?? Color(int.parse('0xFF${data['menu_bg']}')),
      //   'menuBgOn': constDefultHeaderSubBgOnColor ?? Color(int.parse('0xFF${data['menu_bg_on']}')),
      //   'menuFont': constDefultMenuFontColor ?? Color(int.parse('0xFF${data['menu_font']}')),
      //   'menuFontOn': constDefultMenuFontOnColor ?? Color(int.parse('0xFF${data['menu_font_on']}')),
      //   'sessionTopmenuBg': data['session_topmenu_bg'] ?? '',
      //   'sessionTopmenuFont': data['session_topmenu_font'] ?? '',
      // },

      colors: EzvColor(
        menuBg: constDefultHeaderSubBgColor ?? Color(int.parse('0xFF${data['menu_bg']}')),
        menuBgOn: constDefultHeaderSubBgOnColor ?? Color(int.parse('0xFF${data['menu_bg_on']}')),
        menuFont: constDefultMenuFontColor ?? Color(int.parse('0xFF${data['menu_font']}')),
        menuFontOn: constDefultMenuFontOnColor ?? Color(int.parse('0xFF${data['menu_font_on']}')),
        sessionTopmenuBg: constDefultHeaderBgColor ?? Color(int.parse('0xFF${data['session_topmenu_bg']}')),
        sessionTopmenuFont: constDefultHeaderFontColor ?? Color(int.parse('0xFF${data['session_topmenu_font']}')),
      )
            
    );

  

    for (var day in data['day']) {
      ezvItem.value.addDay(EzvDayItem.fromMap(day));
    }

  }

}