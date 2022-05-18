import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:monumento/shared/components/neumorphism.dart';

Widget neumorphicCard({
  required Color? color,
  required Widget? child,
}) => Neumorphic(
      padding: EdgeInsets.all(15),
      style: NeumorphicStyle(
        depth: 3,
        intensity: 1,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
        color: color,
      ),
      child: child
    );