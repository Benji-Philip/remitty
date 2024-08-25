import 'package:flutter/material.dart';

class BackgroundCard extends StatelessWidget {
  final Color cardColor;
  final double curveStr;
  final double top;
  final int animDuration;
  const BackgroundCard(
      {super.key,
      required this.cardColor,
      required this.curveStr,
      required this.top,
      required this.animDuration});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: top,
      child: IgnorePointer(
        ignoring: true,
        child: AnimatedContainer(
            duration: Duration(milliseconds: animDuration),
            width: double.infinity,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(curveStr)),
                color: cardColor)),
      ),
    );
  }
}
