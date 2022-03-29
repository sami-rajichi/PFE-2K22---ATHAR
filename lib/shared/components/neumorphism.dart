import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

Widget neumorphicButton({
  required Color? prColor,
  required Color? sdColor,
  required Widget? child,
  EdgeInsets padding = const EdgeInsets.all(10),
  double depth = 0,
  NeumorphicBoxShape boxShape = const NeumorphicBoxShape.circle(),
}) =>
    Container(
      // padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Neumorphic(
        padding: EdgeInsets.all(2),
        style: NeumorphicStyle(
          color: sdColor,
          depth: depth,
          intensity: 0.6,
          shape: NeumorphicShape.flat,
          boxShape: boxShape,
        ),
        child: NeumorphicButton(
          padding: padding,
          minDistance: -10,
          onPressed: () {},
          style: NeumorphicStyle(
            color: prColor,
            depth: 0.5,
            intensity: 0.8,
            shape: NeumorphicShape.convex,
            boxShape: boxShape,
          ),
          child: child,
        ),
      ),
    );
