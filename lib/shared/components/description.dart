import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:monumento/constants/colors.dart';

Widget description({
  String subtitle = '',
  required String text,
}) =>
    RichText(
      maxLines: 6,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
          text: '${subtitle}',
          style: TextStyle(
              color: AppColors.bigTextColor, 
              fontSize: 17, 
              fontWeight: FontWeight.w900),
          children: [
            TextSpan(
                text: "${text}", 
                style: TextStyle(
                  fontWeight: FontWeight.w500)),
            
          ]),
    );

GestureTapCallback? _seeMore() {
}
