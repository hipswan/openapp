import 'dart:ui';

import 'package:flutter/material.dart';

class OpenappLogo extends StatelessWidget {
  const OpenappLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 32,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/icons/calendar_circle_big.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: -3, sigmaY: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 22.0,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.redAccent,
              ),
              child: Center(
                child: Text(
                  'Open',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Text(
                'App',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
