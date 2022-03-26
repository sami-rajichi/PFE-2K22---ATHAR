import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../../d_b_icons_icons.dart';

Widget ConvexBottomBar({
  Color? backgroundColor,
}) => ConvexAppBar(
        backgroundColor: backgroundColor,
        curveSize: 80,
        top: -12,
        items: [ 
          TabItem(
            icon: DBIcons.augmented_reality,
            title: 'Camera'
          ),
          TabItem(
            icon: Icons.home_filled,
            title: 'Home'
          ),
          TabItem(
            icon: DBIcons.map,
            title: 'Maps'
          )
        ],
        initialActiveIndex: 1,
        onTap: (int i) => print('Tab $i'),
      );