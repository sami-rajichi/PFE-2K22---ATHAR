import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:monumento/components/ar/arUs.dart';

import '../../d_b_icons_icons.dart';
import '../../home.dart';

class ConvexBottomBar extends StatefulWidget {
  
  final Color? backgroundColor; 
  
  const ConvexBottomBar({ 
    Key? key, this.backgroundColor }) : super(key: key);

  @override
  State<ConvexBottomBar> createState() => _ConvexBottomBarState();
}

class _ConvexBottomBarState extends State<ConvexBottomBar> {
  int selectedPage = 1;
  final pages = [ArUs(), Home()];
  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
        backgroundColor: widget.backgroundColor,
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
        initialActiveIndex: selectedPage,
        onTap: (int i){
          setState(() {
            selectedPage = i;
          });
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => pages[i]));
        },
      );
  }
}