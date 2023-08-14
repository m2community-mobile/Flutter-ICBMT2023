import 'package:flutter/material.dart';

class MakeCenterCell extends StatelessWidget {
  String? text;
  Widget? icon;
  Function touched;

  MakeCenterCell({super.key, this.text, this.icon, required this.touched});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        touched();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(15.0),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(74, 155, 201, 1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 35, maxHeight: 32, minWidth: 35, minHeight: 30),
                child: icon,
                // child: Center(child: Placeholder(),),
              ),
            ),
          ),
          if (text != null) ...[
            Expanded(
              flex: 4,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                alignment: Alignment.topCenter,
                child: Text(
                  text ?? '',
                  textScaleFactor: 1.0,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // fontSize: 14.5,
                    fontSize: MediaQuery.of(context).size.width * 0.033 > 14.5 ? 14.5 : MediaQuery.of(context).size.width * 0.033,
                    letterSpacing: -0.5,
                    height: 0.85,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 1.0,                      
                        color: Colors.black.withOpacity(1),                      // color: Colors.red,
                        offset: const Offset(1.2, 0),
                      ),
                    ],
                  ),
                ),
              ),             
            ),
          ],
        ],
      ),
    );
  }
}
