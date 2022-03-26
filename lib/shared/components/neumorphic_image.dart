import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

Widget neumorphicImage({
  required Color? color,
  required Widget? image
}) => Neumorphic(
      padding: EdgeInsets.all(10),
      style: NeumorphicStyle(
        depth: 32,
        intensity: 0.8,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.rect(),
        color: color,
      ),
      child: image,
    );