import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:monumento/components/ar/arUs.dart';
import 'package:monumento/components/categories/categories_home.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class ConvexBottomBar extends StatefulWidget {
  
  final Color? backgroundColor;
  
  const ConvexBottomBar({ 
    Key? key, this.backgroundColor}) : super(key: key);

  @override
  State<ConvexBottomBar> createState() => _ConvexBottomBarState();
}

class _ConvexBottomBarState extends State<ConvexBottomBar> {
  int selectedPage = 1;
  final pages = [ArUs(), NavigationDrawer(), HomeCategories()];
  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
        backgroundColor: Colors.white,
        elevation: 8,
        curveSize: 80,
        top: -12,
        items: [ 
          TabItem(
            icon: Icon(Icons.camera_alt_rounded, color: AppColors.mainColor,),
          ),
          TabItem(
            icon: Icon(Icons.home_filled, color: AppColors.mainColor,),
          ),
          TabItem(
            icon: Icon(Icons.account_balance_rounded, color: AppColors.mainColor,),
          )
        ],
        initialActiveIndex: selectedPage,
        onTap: (int i){
          setState(() {
            selectedPage = i;
          });

          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => pages[selectedPage]));
        },
      );
  }
}