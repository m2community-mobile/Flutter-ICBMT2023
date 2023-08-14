import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../constants.dart';
import '../service/app_service.dart';

class BoothScane extends StatefulWidget {
  BoothScane({super.key});
  static String routeName = '/booth/scane';

  final _appService = AppService.to;

  @override
  State<BoothScane> createState() => _BoothScaneState();
}

class _BoothScaneState extends State<BoothScane> {
  // MobileScannerController cameraController = MobileScannerController();

  Barcode? barcode;
  // BarcodeCapture? capture;

  void onDetect(BarcodeCapture barcode) async {
    // capture = barcode;
    // print('barcode => ${barcode.barcodes.first.rawValue}');
    // setState(() => this.barcode = barcode.barcodes.first);

    controller.dispose();

    Map<String, String> sendData = {
      'deviceid': widget._appService.deviceId,
      'user_sid': widget._appService.userSid.toString(),
      'booth_id': barcode.barcodes.first.rawValue.toString(),
    };

    // debugPrint('dio: ${widget._appService.userSid.toString()}');

    final dio = Dio();
    try {
      final response =
          await dio.get(constUrlBoothEventSend, queryParameters: sendData);
      debugPrint('scan : ${response.statusCode}');
    } on SocketException catch (e) {
      debugPrint('scan : ${e.runtimeType}');
      Fluttertoast.showToast(msg: 'Please check your internet connection.');
      // throw SocketException(e.toString());
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint('scan : ${e.response?.data}');
      } else {
        debugPrint('scan : ${e.message}');
      }
    } finally {
      Get.back(result: 'reload');
    }
  }

  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.code128],
  );

  // MobileScannerArguments? arguments;

  @override
  void dispose() {
    super.dispose();

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      // center: MediaQuery.of(context).size.center(Offset.zero),
      center: Offset(
        MediaQuery.of(context).size.width * 0.5,
        MediaQuery.of(context).size.height * 0.4,
      ),
      width: MediaQuery.of(context).size.width * 0.85,
      // height: MediaQuery.of(context).size.width * 0.85,
      height: 340,
    );

    final double topHeight = MediaQuery.of(context).size.height * 0.35;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.70,
              child: Stack(
                children: [
                  MobileScanner(
                    scanWindow: scanWindow,
                    controller: controller,
                    // onScannerStarted: (arguments) {
                    //   setState(() {
                    //     this.arguments = arguments;
                    //   });
                    // },
                    onDetect: onDetect,
                  ),
                  CustomPaint(
                    painter: ScannerOverlay(scanWindow),
                  ),
                  Align(
                    alignment: FractionalOffset(
                      0.5,
                      1 - MediaQuery.of(context).size.height * 0.0004,
                    ),
                    child: Image.asset(
                      'assets/images/common/booth_scan_zoom@3x.png',
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width * 0.85 + 15,
                      height: 340 + 15,
                    ),
                    // child: Placeholder(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height * 0.375,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  'Please scan the barcode of each booth',
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              )),
          Container(
            width: double.infinity,
            height: topHeight,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
            ),

            child: Stack(children: [
              // Align(
              //   alignment: Alignment.topCenter,
              //   child: Container( // 우상단 마이페이지
              //     transform: Matrix4.translationValues(-40, -10, 0),
              //     padding: const EdgeInsets.only(top: 10),
              //     child: Image.asset(
              //       'assets/images/common/booth_icoScanStamp@3x.png',
              //       height: topHeight * 0.67,
              //       fit: BoxFit.contain,
              //     ),
              //   ),
              // ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom: 20),
              //     child: Image.asset(
              //       'assets/images/common/booth_icoScanTxt@3x.png',
              //       height: topHeight * 0.12,
              //       fit: BoxFit.contain,
              //     ),
              //   ),
              // ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // 우상단 마이페이지
                  // transform: Matrix4.translationValues(-40, -10, 0),
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Image.asset(
                    'assets/images/common/booth_icoScanStamp@3x.png',
                    width: MediaQuery.of(context).size.width * 0.42,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  transform: Matrix4.translationValues(0, 20, 0),
                  child: Image.asset(
                    'assets/images/common/booth_icoScanTxt2.png',
                    width: MediaQuery.of(context).size.width * 0.52,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset(
                          'assets/images/common/btnClosed@2x.png',
                          color: const Color(0xff162162162),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: IconButton(
                        icon: ValueListenableBuilder(
                          valueListenable: controller.torchState,
                          builder:
                              (BuildContext context, value, Widget? child) {
                            if (value == null) {
                              return Image.asset(
                                  'assets/images/common/flashOff@3x.png');
                            }
                            switch (value as TorchState) {
                              case TorchState.off:
                                return Image.asset(
                                    'assets/images/common/flashOff@3x.png');
                              case TorchState.on:
                                return Image.asset(
                                    'assets/images/common/flashOn@3x.png');
                            }
                          },
                        ),
                        onPressed: () {
                          controller.toggleTorch();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            // child: Center(
            //   child: Text(
            //     barcode==null ? "" : barcode!.rawValue.toString()
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow);

  final Rect scanWindow;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()..addRect(scanWindow);

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
