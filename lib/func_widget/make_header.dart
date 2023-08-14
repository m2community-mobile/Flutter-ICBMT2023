import 'package:flutter/material.dart';

import '../data/ezv_item.dart';
import '../service/app_service.dart';
import '../constants.dart';
import '../controller/nav_item_controller.dart';
import '../page/home.dart';


class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    required this.navController,
  });

  final NavItemController navController;


  @override
  Widget build(BuildContext context) {

    final AppService appService = AppService.to;
    EzvColor ezvColors = appService.getColor;
    
    return AppBar(
      centerTitle: true,
      leading: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Home.homeKey.currentState!.openDrawer();
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Icon(
            Icons.menu,
            color: ezvColors.sessionTopmenuFont,
            size: 30,
          ),
          // child: Text('123'),
        ),
      ),
      backgroundColor: ezvColors.sessionTopmenuBg,
      title: GestureDetector(
          onTap: () {
            navController.goHome();
          },
          child: const Text(eventName, textScaleFactor: 1.0,),
        ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(constAppbarHeight);
}

class AppHeaderSub extends StatelessWidget {
  const AppHeaderSub({
    super.key,
    required this.navController,
    required this.title,
  });

  final NavItemController navController;
  final String title;

  @override
  Widget build(BuildContext context) {

    final AppService appService = AppService.to;
    EzvColor ezvColors = appService.getColor;

    return SizedBox(
      height: constAppbarsubHeight,
      child: Stack(
        children: [
          Container(
            color: ezvColors.sessionTopmenuBg,
            alignment: Alignment.center,
            child: Text(
              title,
              textScaleFactor: 1.0,
              style: TextStyle(color: ezvColors.sessionTopmenuFont),
            ),
          ),

          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              navController.goHome();
            },
            child: constIconBack,
          ),
        ],
      ),
    );
  }
}

