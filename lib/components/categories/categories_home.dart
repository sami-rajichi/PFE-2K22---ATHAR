import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monumento/d_b_icons_icons.dart';
import 'package:monumento/shared/components/bottomBar.dart';
import 'package:monumento/shared/components/liquid_swipe_navigator.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/neumorphism.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({Key? key}) : super(key: key);

  @override
  State<HomeCategories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  Map<String, String> classes = {
    'nord': 'assets/map/nord.png',
    'centre': 'assets/map/centre.png',
    'sud': 'assets/map/sud.png',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: MenuWidget(),
          title: Text('Monumento'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: neumorphicButton(
                  child: Icon(
                    DBIcons.search,
                  ),
                  prColor: Colors.indigo.shade500,
                  sdColor: Colors.indigo.shade800),
            )
          ],
          backgroundColor: Colors.indigo[500],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: GestureDetector(
                  child: Image.asset(
                    'assets/map/nord4.png',
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LiquidSwipeNavigator(region: 'nord')));
                  }),
            ),
            Container(
              transform: Matrix4.translationValues(0, -52, 0),
              child: GestureDetector(
                  child: Image.asset(
                    'assets/map/centre4.png',
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LiquidSwipeNavigator(region: 'centre')));
                  }),
            ),
            Container(
              transform: Matrix4.translationValues(0, -52, 0),
              child: GestureDetector(
                  child: Image.asset(
                    'assets/map/sud4.png',
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LiquidSwipeNavigator(region: 'centre')));
                  }),
            ),
          ],
        ),
        bottomNavigationBar:
            ConvexBottomBar(backgroundColor: Colors.indigo[500]));
  }
}
