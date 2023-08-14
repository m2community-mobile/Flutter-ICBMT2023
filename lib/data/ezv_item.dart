import 'package:flutter/material.dart';
import '../data/app_version.dart';

class EzvItem {
  String? dayType;
  String? tab;
  String? mon;
  // Map? colors;
  EzvColor? colors;
  AppVersion appVersion;

  List<EzvDayItem> day = [];

  EzvItem({
    this.dayType,
    this.tab,
    this.mon,
    this.colors,
    appVersion,
  }) : appVersion = appVersion ?? AppVersion();

  void addDay(EzvDayItem ezvDayItem) {
    day.add(ezvDayItem);
  }
}

class EzvDayItem {
  String tab;
  String name; //day_type : 1       일 경우 사용
  String week; //day_type : 2 or 3  일 경우 사용
  String day; //day_type : 2 or 3   일 경우 사용
  String date;

  EzvDayItem({required this.tab, required this.name, required this.week, required this.day, required this.date});

  factory EzvDayItem.fromMap(Map<String, dynamic> map) {
    print("map: $map");
    return EzvDayItem(
      tab: map['tab'].toString(),
      name: map['name'] as String? ?? '',
      week: map['week'] as String? ?? '',
      day: map['day'] as String? ?? '',
      date: map['date'] as String? ?? '',
    );
  }

  String get getDate => date;
}

class EzvColor {
  Color menuBg;
  Color menuBgOn;
  Color menuFont;
  Color menuFontOn;
  Color sessionTopmenuBg;
  Color sessionTopmenuFont;

  EzvColor({
    required this.menuBg, 
    required this.menuBgOn,
    required this.menuFont,
    required this.menuFontOn,
    required this.sessionTopmenuBg,
    required this.sessionTopmenuFont,
  });

}
