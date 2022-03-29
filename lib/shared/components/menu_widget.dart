import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:monumento/d_b_icons_icons.dart';
import 'package:monumento/shared/components/neumorphism.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => CircleAvatar(
          radius: 30,
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          child: neumorphicButton(
            child: GestureDetector(
              onTap: () => ZoomDrawer.of(context)!.toggle(),
              child: Icon(DBIcons.menu, size: 24,)),
            prColor: Colors.indigo[500],
            sdColor: Colors.indigo[800]),
        );
}