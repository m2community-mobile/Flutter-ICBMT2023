import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PDFViewer extends StatelessWidget {
  PDFViewer({Key? key, required this.url}) : super(key: key);

  final String url;
  
  final Completer<PDFViewController> _pdfViewController = Completer<PDFViewController>();
  final StreamController<String> _pageCountController = StreamController<String>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Cached PDF From Url'),
      // ),
      body: Stack(
        children: [
          Container(
            child: PDF(
              onViewCreated: (PDFViewController pdfViewController) async {
                _pdfViewController.complete(pdfViewController);
                final int currentPage = await pdfViewController.getCurrentPage() ?? 0;
                final int? pageCount = await pdfViewController.getPageCount();
                _pageCountController.add('${currentPage + 1} - $pageCount');
              },
          
            ).cachedFromUrl(
              url,
              placeholder: (double progress) {
                return Center(
                  child: CircularPercentIndicator(
                    radius: 30.0,
                    lineWidth: 5.0,
                    percent: progress * 0.01,
                    center: Text("${progress.floor()}%"),
                    progressColor: Colors.blue,
                  ),
                );
              },
              errorWidget: (dynamic error) => Center(child: Text(error.toString())),
            ),
          ),
          Positioned(
            right: 5,
            top: MediaQuery.of(context).padding.top + 5,
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
        ],
      ),

      // floatingActionButton: FutureBuilder<PDFViewController>(
      //   future: _pdfViewController.future,
      //   builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
      //     if (snapshot.hasData && snapshot.data != null) {
      //       return Row(
      //         mainAxisSize: MainAxisSize.max,
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: <Widget>[
      //           FloatingActionButton(
      //             heroTag: '-',
      //             child: const Text('-'),
      //             onPressed: () async {
      //               final PDFViewController pdfController = snapshot.data!;
      //               final int currentPage =
      //                   (await pdfController.getCurrentPage())! - 1;
      //               if (currentPage >= 0) {
      //                 await pdfController.setPage(currentPage);
      //               }
      //             },
      //           ),
      //           FloatingActionButton(
      //             heroTag: '+',
      //             child: const Text('+'),
      //             onPressed: () async {
      //               final PDFViewController pdfController = snapshot.data!;
      //               final int currentPage =
      //                   (await pdfController.getCurrentPage())! + 1;
      //               final int numberOfPages = await pdfController.getPageCount() ?? 0;
      //               if (numberOfPages > currentPage) {
      //                 await pdfController.setPage(currentPage);
      //               }
      //             },
      //           ),
      //         ],
      //       );
      //     }
      //     return const SizedBox();
      //   },
      // ),

    );
  }
}