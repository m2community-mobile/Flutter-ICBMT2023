import 'dart:async';

import 'package:flutter/material.dart';

class MainBoothIcon extends StatefulWidget {

  double height;

  MainBoothIcon(this.height);

  @override
  _MainBoothIconState createState() => _MainBoothIconState();
}

class _MainBoothIconState extends State<MainBoothIcon> {
  final _animationDuration = const Duration(milliseconds: 500);
  late Timer _timer;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_animationDuration, (timer) => _changeColor());
    _color = Color.fromRGBO(40, 63, 173, 1);
  }

  void _changeColor() {
    final newColor = _color == Color.fromRGBO(40, 63, 173, 1) ? Colors.white : Color.fromRGBO(40, 63, 173, 1);
    setState(() {
      _color = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      child: Image.asset('assets/images/icons/homeIconBooth@2x.png', color: _color, height: widget.height,),
      duration: _animationDuration,
      // color: _color,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}