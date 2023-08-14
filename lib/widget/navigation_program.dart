import 'package:flutter/material.dart';
import '../constants.dart';
import '../service/app_service.dart';
import '../controller/nav_item_controller.dart';
import '../data/ezv_item.dart';

class NavProgram extends StatelessWidget {
  const NavProgram({super.key});

  @override
  Widget build(BuildContext context) {
    
    final navController = NavItemController.to;
    // final appService = AppService.to;

    // List<EzvDayItem> dayList = appService.getDayRemoveNull;

    const textStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.white);

    return Container(
      color: const Color.fromRGBO(23, 29, 71, 1),
      padding: const EdgeInsets.only(left: 15.0),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              navController.goDirect('glance');
            },
            child: const Text('• Program at a Glance', textScaleFactor: 1.0, style: textStyle,),
          ),

          // for (EzvDayItem item in dayList) ...[
            
          //   GestureDetector(
          //     onTap: () {
          //       navController.webView('program', param: {'tab':item.tab});
          //     },                       
          //     child: SizedBox(
          //       width: double.infinity,
          //       child: Text('• ${ item.name }', textScaleFactor: 1.0, style: textStyle,),
          //     ),
          //   ),
          // ]
          for (EventDay event in eventDays) ...[
            GestureDetector(

              onTap: () {
                // navController.webView('program_day${event.day}');
                navController.webView('program', param: {'tab':event.index.toString()});
              },                       
              child: SizedBox(
                width: double.infinity,
                child: Text('• ${event.titie}', textScaleFactor: 1.0, style: textStyle,),
              ),
            ),
          ],
        ],
      ),
    );
    
  }
}

