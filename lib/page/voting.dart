import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:icbmt2023/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/app_service.dart';

// import 'getdevice.dart';

class VotingWidget extends StatefulWidget {
  VotingWidget({super.key});
  static String routeName = '/voting';

  final AppService _appService = AppService.to;

  @override
  State<VotingWidget> createState() => _VotingWidgetState();
}

class _VotingWidgetState extends State<VotingWidget> {

  

  Future<bool?> showAlert(String msg) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void sendChk(String val) async {
    // String deviceid = await getDeviceIdentifier();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final String name = prefs.getString('name') ?? "";
    // final String office = prefs.getString('office') ?? "";

    final sendData = {
      'val': val,
      'code': eventCode,
      'deviceid': widget._appService.deviceId,
      // 'office': office,
      'device': Platform.isAndroid ? 'android' : 'IOS',
      // 'name': name,
      'mobile': 'Y',
    };

    // print(sendData);

    final dio = Dio();
    final response = await dio.post(
      'https://ezv.kr:4447/voting/php/voting/app/post.php',
      queryParameters: sendData,
    );

    final String result = response.toString();
    // print(result);

    // String result = '3';

    if(result == "1") {
      // showAlert('보팅이 제출되었습니다.');
      showAlert('Has been involved.');
    } else if(result == "2") {
      // showAlert('보팅이 수정되었습니다.');
      showAlert('제출하신 보팅결과를 변경하였습니다.');
    } else {
      // showAlert('현재 진행중인 보팅이 없습니다.');
      showAlert('There are currently no active voting.');
    }

  }

  @override
  Widget build(BuildContext context) {
    const double btnHeight = 80.0;
    const EdgeInsets btnPadding =
        EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0);
    const TextStyle btnTextStyle = TextStyle(fontSize: 30.0);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: 80.0,
                  child: Stack(
                    children: [
                      const Center(
                        child: Text(
                          "Voting",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        // top: MediaQuery.of(context).padding.top + 5,
                        top: 5,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade400,
                          radius: 15,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.close_rounded,),
                            color: Colors.white,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   child: Container(
                      //     padding: EdgeInsets.all(25),
                      //     child: Icon(
                      //       Icons.home_outlined,
                      //       size: 34,
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     Navigator.of(context).pop();
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  // color: Colors.cyan[100],
                  border: Border.all(
                    color: Color.fromRGBO(220, 220, 220, 1),
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.only(
                  top: 80,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    // Text(
                    //   '문제를 보시고 아래 번호를 선택해 주세요.',
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    const AutoSizeText(
                      // '문제를 보시고 아래 번호를 선택해 주세요.',
                      'Please Select the Answer',
                      style: TextStyle(fontSize: 18),
                      maxLines: 1,
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: btnPadding,
                      child: SizedBox(
                        width: double.infinity,
                        height: btnHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () {
                            sendChk('1');
                          },
                          child: const Text(
                            "NO. 1",
                            style: btnTextStyle,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: btnPadding,
                      child: SizedBox(
                        width: double.infinity,
                        height: btnHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () {
                            sendChk('2');
                          },
                          child: const Text(
                            "NO. 2",
                            style: btnTextStyle,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: btnPadding,
                      child: SizedBox(
                        width: double.infinity,
                        height: btnHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () {
                            sendChk('3');
                          },
                          child: const Text(
                            "NO. 3",
                            style: btnTextStyle,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: btnPadding,
                      child: SizedBox(
                        width: double.infinity,
                        height: btnHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () {
                            sendChk('4');
                          },
                          child: const Text(
                            "NO. 4",
                            style: btnTextStyle,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: btnPadding,
                      child: SizedBox(
                        width: double.infinity,
                        height: btnHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                          onPressed: () {
                            sendChk('5');
                          },
                          child: const Text(
                            "NO. 5",
                            style: btnTextStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        //WebViewWidget(controller: _controller),
      ),
    );
  }
}
