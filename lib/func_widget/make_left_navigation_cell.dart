import 'package:expansion_tile_group/expansion_tile_group.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class MakeLeftNavigationCell {
  Widget? leading;
  final Widget title;
  final Function touched;
  final bool menuExpanded;
  List<ConstMenuLink> subMenus;

  MakeLeftNavigationCell({
    this.leading,
    required this.title,
    required this.touched,
    menuExpanded,
    subMenus,
  }) : subMenus = subMenus ?? [], menuExpanded = menuExpanded ?? false;

  ExpansionTileItem build() {
    const Color menuTextColor = Color.fromRGBO(22, 104, 179, 1);
    const Color menuTailColor = Color.fromRGBO(25, 42, 67, 1);

    const Color subMenuColor = Color.fromRGBO(241, 242, 247, 1);
    const EdgeInsets subMenuTextPadding = EdgeInsets.only(left: 45.0);
    const double subMenuHeight = 35.0;

    return ExpansionTileWithoutBorderItem(
      decoration: const BoxDecoration(
        border: Border(
          bottom:
              BorderSide(color: Color.fromRGBO(218, 218, 218, 1), width: 0.5), // 구분선
        ),
      ),
      textColor: menuTextColor,
      iconColor: menuTailColor,
      childrenPadding: EdgeInsets.zero,
      collapsedBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      title: title,
      leading: leading,
      trailing: subMenus.isNotEmpty ? null : const SizedBox.shrink(),
      initiallyExpanded: menuExpanded,
      onExpansionChanged: (value) {
        touched();
      },
      children: subMenus.isEmpty
        ? []
        : [
            Container(
              width: double.infinity,
              color: subMenuColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (ConstMenuLink subMenu in subMenus)
                    GestureDetector(
                      onTap: () {
                        subMenu.touched();
                      },
                      child: Container(
                        color: subMenuColor,
                        height: subMenuHeight,
                        alignment: Alignment.centerLeft,
                        padding: subMenuTextPadding,
                        child: Text("- ${subMenu.title}", textScaleFactor: 1.0,),
                      ),
                    ),
                ],
              ),
            ),
          ],
    );
  }
}