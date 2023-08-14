import 'package:flutter/material.dart';
import '../data/nav_item.dart';

class MakeBottomNavigation extends StatefulWidget {
  final Color color;
  final double height;
  final List<NavItem> children;
  final double? marginBottom;

  const MakeBottomNavigation({super.key, 
    required this.color,
    required this.height,
    required this.children,
    this.marginBottom,
  });

  @override
  State<MakeBottomNavigation> createState() => _MakeBottomNavigationState();
}

class _MakeBottomNavigationState extends State<MakeBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height + (widget.marginBottom ?? 0),
      color: widget.color,
      child: Column(
        children: [
          SizedBox(
            height: widget.height,
            child: _menu(),
            // child: Row(
            //   chk
            //   Text('1'),
            //   Text('1'),
            //   Text('1'),
            //   Text('1'),
            // ),
          ),
          SizedBox(height: widget.marginBottom ?? 0),
        ],
      ),
    );
  }

  Row _menu() {
    return Row(
      children: [
        for (NavItem item in widget.children)
          Expanded(
            child: InkWell(
              onTap: () {
                item.touched();
              },
              child: Container(
                color: item.backgroundColor,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: item.iconPadding,
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: item.icon,
                        ),
                      ),
                    ),
                    if (item.text != null) ...[
                      Expanded(
                        flex: 4,
                        child: SizedBox(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(                              
                              item.text ?? '',
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: item.textStyle,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
