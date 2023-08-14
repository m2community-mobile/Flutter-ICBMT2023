

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../data/ezv_item.dart';
import '../data/app_version.dart';

class AppService extends GetxService {
  static AppService get to => Get.isRegistered<AppService>() ? Get.find<AppService>() : Get.put(AppService());

  final RxBool _isLogined = false.obs;
  final RxInt _userSid = 0.obs;
  final RxString _deviceId = "".obs;

  int get userSid => _userSid.value;
  bool get isLogined => _isLogined.value;
  String get deviceId => _deviceId.value;


  final RxBool _isEzvInitialized = false.obs;
  final Rx<EzvItem> ezvItem = EzvItem().obs;

  bool get isEzvInitialized => _isEzvInitialized.value;
  get getColor => ezvItem.value.colors;
  String? get tab => ezvItem.value.tab;
  String? get mon => ezvItem.value.mon;
  String? get dayType => ezvItem.value.dayType;
  AppVersion get appVersion => ezvItem.value.appVersion;

  List<EzvDayItem> get getDay => ezvItem.value.day;
  List<EzvDayItem> get getDayRemoveNull {
    List<EzvDayItem> result = [];
    for(EzvDayItem item in ezvItem.value.day) {
      if(item.tab == '-1') continue;
      result.add(item);
    }
    return result;
  }



  // 로그인 관련
  Future<bool> login(Map<String, dynamic> queryParameters) async {

    final dio = Dio();
    final response = await dio.get(constUrlLogin, queryParameters: queryParameters);

    final result = jsonDecode(response.toString());
    
    if (result['rows'] == 'Y') {

      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setInt('user_sid', int.parse(result['user_sid']));
      prefs.setString('isLogin_$eventCode', 'Y');

      _userSid.value = result['user_sid'];
      _isLogined.value = true;

      return true;
    } else {
      return false;
    }
  }


  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _userSid.value = 0;
    _isLogined.value = false;
  }
  

  // 로그인 체크시 사용
  Future<bool> isLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((prefs.getString('isLogin_$eventCode') ?? '') == 'Y') { 
      
      _deviceId.value = prefs.getString('deviceid') ?? '';
      _userSid.value = prefs.getInt('user_sid') ?? 0;
      _isLogined.value = true;
    }

    return isLogined;
  }

  // 로그인 관련 끝
  


  // ezv 관련
  Future<void> initEzvSetting() async {
    if(_isEzvInitialized.value == false) {
      await getEzvSetting();
      _isEzvInitialized.value = true;

      debugPrint('AppService: AppService EzvItem initialize!!');
      log('AppService EzvItem initialize!!', name: 'AppService');
    }
  }
 
  Future<void> getEzvSetting() async {

    final dio = Dio();

    // ezv 정보를 가져와 셋팅    
    final responseGetSet = await dio.get(constUrlGetSet);
    final getSetData = jsonDecode(responseGetSet.toString());
    
    debugPrint('AppService: ${getSetData.toString()}');
    log(getSetData.toString(), name: 'AppService');
    setEzvData(getSetData);
  }

  void setEzvData(Map data) {

    String versionMin = ''; //최소 버전  
    String versionLastest = ''; //마지막 버전
    String versionLastestGuideShow = ''; //마지막 버전보다 낮을경우 안내여부
    
    if (Platform.isAndroid) {
      versionMin = data['version']['android']['min'] ?? '';
      versionLastest = data['version']['android']['lastest'] ?? '';
      versionLastestGuideShow = data['version']['android']['lastest_popup_show'] ?? '';
    } else if (Platform.isIOS) {
      versionMin = data['version']['IOS']['min'] ?? '';
      versionLastest = data['version']['IOS']['lastest'] ?? '';
      versionLastestGuideShow = data['version']['IOS']['lastest_popup_show'] ?? '';
    }



    ezvItem.value = EzvItem(
      dayType: data['day_type'],
      tab: data['tab'],
      mon: data['mon'],

      colors: EzvColor(
        menuBg: constDefultHeaderSubBgColor ?? Color(int.parse('0xFF${data['menu_bg']}')),
        menuBgOn: constDefultHeaderSubBgOnColor ?? Color(int.parse('0xFF${data['menu_bg_on']}')),
        menuFont: constDefultMenuFontColor ?? Color(int.parse('0xFF${data['menu_font']}')),
        menuFontOn: constDefultMenuFontOnColor ?? Color(int.parse('0xFF${data['menu_font_on']}')),
        sessionTopmenuBg: constDefultHeaderBgColor ?? Color(int.parse('0xFF${data['session_topmenu_bg']}')),
        sessionTopmenuFont: constDefultHeaderFontColor ?? Color(int.parse('0xFF${data['session_topmenu_font']}')),
      ),

      appVersion: AppVersion(
        min: versionMin, 
        lastest: versionLastest, 
        lastestGuideShow: versionLastestGuideShow
      ),
    );

    for (var day in data['day']) {
      ezvItem.value.addDay(EzvDayItem.fromMap(day));
    }

  }
  // ezv 관련



  Future<void> setDeviceId() async {

    String deviceIdentifier = "";

    if(deviceId == "") {
      if (Platform.isAndroid) {
        
        AndroidId androidIdPlugin = const AndroidId();
        deviceIdentifier = await androidIdPlugin.getId() ?? '';

      } else if (Platform.isIOS) {

        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();        
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        deviceIdentifier = iosInfo.identifierForVendor ?? '';
      }

      _deviceId.value = deviceIdentifier;

    }    

  }

  Future<void> setTokenToServer() async {
    String token = await FirebaseMessaging.instance.getToken() ?? ''; 
    // String token = '';
    // log('토큰값 작업후 주석 확인 app_service.dart', name: '개발확인');

    final dio = Dio();

    debugPrint('deviceId : $deviceId');
    debugPrint('token : $token');

    try {     
      // token 셋팅
      final responseSetToken = await dio.get(constUrlSetToken, queryParameters: {
        'deviceid' : deviceId,
        'code' : eventCode,
        // 'code' : 'flutter_push2',
        'device' : Platform.isAndroid ? 'android' : 'IOS',
        'pushCode' : 'flutter', //고정값
        'token' : token,
      });

      log('로그인 없을 경우 사용', name: '개발확인');
      int responseUserSid = int.parse(responseSetToken.toString());

      if(isLogined == false || (userSid != responseUserSid && responseUserSid > 0) ) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('user_sid', responseUserSid);
        
        _userSid.value = responseUserSid;
        _isLogined.value = true;
      }
      
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response?.data);

      } else {
        rethrow;
      }
    }
    
    
  }

  Future<bool> compareVersion() async {

    if(isEzvInitialized) {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      // appVersion.getAndroidStoreVersion(packageInfo);

      final bool result = await appVersion.compare(packageInfo.version);
      if(result == false) return false;
    }

    //isEzvInitialized 안되면 비교 할수 없기 때문에 일단 ture;
    return true;
  }


  Future<String> getStoreVersion() async {
    if(Platform.isAndroid) {
      return getAndroidStoreVersion();
    } else if(Platform.isIOS) {
      return getIosStoreVersion();
    }
    return '';    
  }

  Future<String> getIosStoreVersion() async {

    String url = 'https://itunes.apple.com/lookup?bundleId=$bundleIdIOS';

    final dio = Dio();
    final Options options = Options(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    var results = await dio.get(url, options: options);

    Map<String, dynamic> result = jsonDecode(results.data);

    
    if(result.isNotEmpty && result['resultCount'] > 0) {
      return result['results'][0]['version'];
    } else {
      return '';
    }
  }


  Future<String> getAndroidStoreVersion() async {
    const id = bundleIdAndroid;
    // const id = 'com.m2comm.icorl2023';

    final uri = Uri.https("play.google.com", "/store/apps/details", {"id": id.toString()});
    final response = await http.get(uri);
    
    if (response.statusCode == 200) {
    
      // Supports 1.2.3 (most of the apps) and 1.2.prod.3 (e.g. Google Cloud)
      //final regexp = RegExp(r'\[\[\["(\d+\.\d+(\.[a-z]+)?\.\d+)"\]\]');
      final regexp =
          RegExp(r'\[\[\[\"(\d+\.\d+(\.[a-z]+)?(\.([^"]|\\")*)?)\"\]\]');
      final rawStoreVersion = regexp.firstMatch(response.body)?.group(1);

      //Description
      //final regexpDescription = RegExp(r'\[\[(null,)\"((\.[a-z]+)?(([^"]|\\")*)?)\"\]\]');
      
      final storeVersion = _getCleanVersion(rawStoreVersion ??'');
      return storeVersion;
    }
    return '';
    
  }

  String _getCleanVersion(String version) =>
      RegExp(r'\d+\.\d+(\.\d+)?').stringMatch(version) ?? '0.0.0';

}