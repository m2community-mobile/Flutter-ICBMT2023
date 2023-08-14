import 'package:flutter/material.dart';

class NavItem {

  bool active;
  Widget icon;
  final Function touched;
  
  // final color = Colors.white;
  // final hoverColor = Colors.green;
  final TextStyle? textStyle;
  final EdgeInsets? iconPadding;

  String? text;
  Color? backgroundColor;

  NavItem({
    required this.active,
    required this.icon,
    required this.touched,
    this.text,
    this.textStyle,
    this.iconPadding,
    this.backgroundColor,
  });
}