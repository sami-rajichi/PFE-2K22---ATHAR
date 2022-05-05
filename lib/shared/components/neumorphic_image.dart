import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

Widget neumorphicImage({
  required Color? color,
  required Widget? image
}) => Neumorphic(
      padding: EdgeInsets.all(5),
      style: NeumorphicStyle(
        depth: 32,
        intensity: 0.6,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
        color: color,
      ),
      child: image,
    );