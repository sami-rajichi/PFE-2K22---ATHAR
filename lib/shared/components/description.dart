import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget description({
  String subtitle = '',
  required String text,
}) =>
    RichText(
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
          text: '${subtitle}',
          style: TextStyle(
              color: Colors.black, 
              fontSize: 15, 
              fontWeight: FontWeight.w600),
          children: [
            TextSpan(
                text: "${text}", 
                style: TextStyle(
                  fontWeight: FontWeight.w500)),
            
          ]),
    );

GestureTapCallback? _seeMore() {
}
