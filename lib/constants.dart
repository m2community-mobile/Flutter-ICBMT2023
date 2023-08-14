import 'package:flutter/material.dart';

const ezvUrl = 'https://ezv.kr:4447';
const eventSiteDomain = 'ezv.kr'; //웹뷰에서 사용 (인앱 웹뷰)
const eventName = 'ICBMT 2023';
const eventCode = 'ICBMT2023';

// const bundleIdAndroid = 'com.m2comm.icorl2023';
// const bundleIdIOS = 'kr.or.icorl2023';
const bundleIdAndroid = 'com.m2comm.icbmt2023';
const bundleIdIOS = 'kr.co.m2community.icbmt2023';

const eventDays = [
  EventDay(index: 462, day: 1, titie: 'August 31 (Thu)'),
  EventDay(index: 463, day: 2, titie: 'September 1 (Fri)'),
  EventDay(index: 464, day: 3, titie: 'September 2 (Sat)'),
];

class EventDay {
  final int index;
  final int day;
  final String titie;

  const EventDay({required this.index, required this.day, required this.titie});
}

// base url
const constUrlSetToken = "$ezvUrl/voting/php/token.php?code=$eventCode";
const constUrlGetPush = "$ezvUrl/voting/php/bbs/get_push.php?code=$eventCode";
// const constUrlGetPush = "$ezvUrl/voting/php/bbs/get_push.php?code=flutter_push2";
// const constUrlSetPush = "$ezvUrl/voting/php/bbs/set_push.php?code=flutter_push2";
const constUrlSetPush = "$ezvUrl/voting/php/bbs/set_push.php?code=$eventCode";


const constUrlLogin = "$ezvUrl/voting/php/login/icorl2023.php";
const constUrlGetSet = "$ezvUrl/voting/php/session/get_set.php?code=$eventCode";
const constUrlGlance = "$ezvUrl/voting/php/session/glance.php?code=$eventCode&deviceid={deviceid}";
const constUrlPhoto = "$ezvUrl/voting/php/photo/get_photo.php?code=$eventCode";
const constUrlPhotoFavor = "$ezvUrl/voting/php/photo/set_favor.php?code=$eventCode";
const constUrlPhotoUpload = "$ezvUrl/voting/php/photo/photo_upload.php?code=$eventCode";
const constUrlBoothEvent = "$ezvUrl/voting/php/booth/event.php?code=$eventCode&deviceid={deviceid}&user_sid={user_sid}&include=Y";
const constUrlBoothEventCnt = "$ezvUrl/voting/php/booth/get_event_cnt.php?code=$eventCode";
const constUrlBoothEventSend = "$ezvUrl/voting/php/booth/add_event.php?code=$eventCode&chk=Y";
const constUrlBoothEventGift = "$ezvUrl/voting/php/booth/draw.php?code=$eventCode";

const constUrlNoticeList = "$ezvUrl/voting/php/bbs/get_list.php?code=$eventCode";
const constUrlSponsorList = "$ezvUrl/voting/php/booth/get_list.php?code=$eventCode"; //main marquee sponsor images


// const constUrlPhoto = "$ezvUrl/voting/php/photo/get_photo.php?code=korl2022";
// const constUrlPhotoFavor = "$ezvUrl/voting/php/photo/set_favor.php?code=korl2022";
// const constUrlPhotoUpload = "$ezvUrl/voting/php/photo/photo_upload.php?code=korl2022";

const constUrlPhotoDelete = "$ezvUrl/voting/php/photo/del_photo.php?code=$eventCode";
const constUrlPhotoFile = "$ezvUrl/voting/upload/photo/";


// basic String
const String constTextYes = 'Yes';
const String constTextNo = 'No';
const String constTextConfirm = 'Confirm';
const String constTextNotice = 'Notice';
const String constTextLogout = 'Logout';

// application update
const String constUpdateTitle = 'Update Available';
const String constUpdateContent = 'You can now update this app.';
const String constUpdateMustTitle = 'Update';
const String constUpdateMustContent = 'Available after update.';
const String constUpdateLater = 'LATER';
const String constUpdateNOW = 'UPDATE NOW';

// dialog
const ShapeBorder constDialogShape = RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)));

// dialog - logout
// const Widget constDialogLogoutTitle = Text("Notice", textScaleFactor: 1.0,);
// const Widget constDialogLogout = Text('Logout?', textScaleFactor: 1.0,);
const String constDialogLogoutTitle = 'Notice';
const String constDialogLogout = 'Logout?';

// dialog - photo
const Widget constDialogPhotoDeleteTitle = Text("Delete", textScaleFactor: 1.0,);
const Widget constDialogmPhotoDelete = Text("Are you sure you want to delete?", textScaleFactor: 1.0,);

const String constMessagePhotoDownComplete = "Complete."; // photo down
const Widget constDialogPhotoTitleEmpty = Text('Please enter the title of the photo first.', textScaleFactor: 1.0,);

// alarm
const String constTextAlarm = 'Alarm';
const String constTextAddAlarm = 'Add alarm complete';
const String constTextRemoveAlarm = 'Remove alarm complete';

class ConstWebpage {
  final String title;
  final String url;
  String? menuNum;

  ConstWebpage({required this.title, required this.url, this.menuNum});
}

class ConstWebPageList {
  
  List<ConstWebpage> webViewPages = [
    ConstWebpage(
      title: 'program',
      url: '$ezvUrl/voting/php/session/list.php?code=$eventCode&deviceid={deviceid}',
      menuNum: '3'
    ),
    for (EventDay event in eventDays) ...[
      ConstWebpage(
        title: 'program_day${event.day}',
        url: '$ezvUrl/voting/php/session/list.php?code=$eventCode&tab=${event.index}&deviceid={deviceid}',
        menuNum: '3'),
    ],
    
    ConstWebpage(
        title: 'welcome',
        url: '$ezvUrl/icbmt2023/html/contents/welcome.html',
        menuNum: '1'),
    ConstWebpage(
        title: 'abstract',
        url: '$ezvUrl/voting/php/abstract/category.php?code=$eventCode&deviceid={deviceid}'),
    ConstWebpage(
        title: 'faculty',
        url: '$ezvUrl/voting/php/faculty/list.php?code=$eventCode&deviceid={deviceid}'),
    ConstWebpage(
        title: 'survey',
        url: '$ezvUrl/icbmt2023/html/contents_dev/survey.html?deviceid={deviceid}'),
    ConstWebpage(
        title: 'newsletter',
        url: '$ezvUrl/icbmt2023/html/contents/newsletter.html'),
    ConstWebpage(
        title: 'sponsor',
        url: '$ezvUrl/voting/php/booth/list.php?code=$eventCode&deviceid={deviceid}',
        menuNum: '7'),
    ConstWebpage(
        title: 'exhibition',
        url: '$ezvUrl/icbmt2023/html/contents/exhibition.html?code=$eventCode&deviceid={deviceid}',
        menuNum: '7'),

    ConstWebpage(
        title: 'overview',
        url: '$ezvUrl/icbmt2023/html/contents/overview.html',
        menuNum: '1'),
    ConstWebpage(
        title: 'committee',
        url: '$ezvUrl/icbmt2023/html/contents/committee.html',
        menuNum: '1'),
    ConstWebpage(
        title: 'past',
        url: '$ezvUrl/icbmt2023/html/contents/past.html',
        menuNum: '1'),
    ConstWebpage(
        title: 'venue',
        url: '$ezvUrl/icbmt2023/html/contents/venue.html',
        menuNum: '2'),
    ConstWebpage(
        title: 'transportation',
        // url: '$ezvUrl/icbmt2023/html/contents/transportation_01_a.html',
        url: '$ezvUrl/icbmt2023/html/contents/transportation_03.html',
        menuNum: '2'),
    ConstWebpage(
        title: 'floor',
        url: '$ezvUrl/icbmt2023/html/contents/floor.html',
        menuNum: '2'),

    ConstWebpage(
        title: 'notice',
        url: '$ezvUrl/voting/php/bbs/list.php?code=$eventCode&deviceid={deviceid}'),
    ConstWebpage(
        title: 'notice_view',
        url: '$ezvUrl/voting/php/bbs/view.php?code=$eventCode&deviceid={deviceid}'),
    ConstWebpage(
        title: 'now',
        url: '$ezvUrl/voting/php/session/list.php?tab=-1&code=$eventCode&deviceid={deviceid}',
        menuNum: '3'),
    ConstWebpage(
        title: 'search',
        url: '$ezvUrl/voting/php/session/list.php?tab=-3&code=$eventCode&deviceid={deviceid}'),
    ConstWebpage(
        title: 'favorite',
        url: '$ezvUrl/voting/php/session/list.php?tab=-2&code=$eventCode&deviceid={deviceid}',
        menuNum: '3'),
    ConstWebpage(
        title: 'memo',
        url: '$ezvUrl/voting/php/session/list.php?tab=-6&code=$eventCode&deviceid={deviceid}',
        menuNum: '3'),
  ];

  int getIndex(String title) {
    return webViewPages.indexWhere((e) => e.title == title);
  }

  String getMenuNum(int index) {
    if(index < 0) return '';
    return webViewPages[index].menuNum ?? '';
  }

}


//앱별 고정값
const leftNavBackgoundColor = Color.fromRGBO(38, 55, 119, 1); //좌측 네비게이션 배경색
const double constBottomNaviHeight = 60.0; //하단 메뉴 높이

const double constAppbarHeight = 60.0;
const double constAppbarsubHeight = 40.0;

const constDefultHeaderBgColor = null;
const constDefultHeaderFontColor = null;

const constDefultHeaderSubBgColor = null;
const constDefultHeaderSubBgOnColor = Color.fromRGBO(25, 42, 67, 1);
const constDefultHeaderSubFontColor = null;
const constDefultHeaderSubFontOnColor = null;

const constDefultMenuFontColor = null;
const constDefultMenuFontOnColor = null;

const constDefultFooterBgColor = Color.fromRGBO(25, 42, 67, 1); //좌측 네비게이션 배경색
const constDefultFooterFontColor = null;


class ConstMenuLink {
  final String title;
  final Function touched;

  ConstMenuLink({required this.title, required this.touched});
}

//공동 아이콘
const Widget constIconBack = Padding(
  padding: EdgeInsets.fromLTRB(5, 8, 0, 0),
  child: Icon(
    Icons.arrow_back,
    color: Colors.white,
  ),
);