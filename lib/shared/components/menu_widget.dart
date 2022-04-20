import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:monumento/d_b_icons_icons.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
              onTap: () => ZoomDrawer.of(context)!.toggle(),
              child: Icon(DBIcons.menu, size: 22,)
        );
}