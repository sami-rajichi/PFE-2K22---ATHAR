import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:monumento/shared/components/neumorphism.dart';

Widget neumorphicCard({
  required Color? color,
  required Widget? child,
}) => Neumorphic(
      padding: EdgeInsets.all(15),
      style: NeumorphicStyle(
        depth: 15,
        intensity: 0.8,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.rect(),
        color: color,
      ),
      child: child
    );