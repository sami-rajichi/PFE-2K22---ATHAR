import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monumento/constants/colors.dart';
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
  Color color = Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: MenuWidget(),
          title: Text('Monumento'),
          backgroundColor: AppColors.mainColor,
          centerTitle: true,
        ),
        body: Center(
          child: Stack(
            children: [
              InkWell(
                highlightColor: Colors.indigo.withOpacity(0.3),
                splashColor: Colors.indigo.withOpacity(0.5),
                onTap: () {
                  setState(() {
                    color = Colors.indigo.withOpacity(0.3);
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LiquidSwipeNavigator(region: 'nord')));
                },
                child: Container(
                  child: Ink(
                    child: Image.asset(
                      'assets/map/nord.png',
                      height: 500,
                      fit: BoxFit.cover,
                      color: color,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                  child: Image.asset(
                    'assets/map/center.png',
                    height: 500,
                    fit: BoxFit.cover,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LiquidSwipeNavigator(region: 'centre')));
                  }),
              InkWell(
                highlightColor: Colors.indigo.withOpacity(0.3),
                splashColor: Colors.indigo.withOpacity(0.5),
                onTap: () {
                  setState(() {
                    color = Colors.indigo.withOpacity(0.3);
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LiquidSwipeNavigator(region: 'nord')));
                },
                child: Ink(
                  child: Image.asset(
                    'assets/map/sud.png',
                    height: 500,
                    fit: BoxFit.cover,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            ConvexBottomBar(
              backgroundColor: AppColors.mainColor
        )
      );
  }
}
