import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:monumento/components/ar/arUs.dart';
import 'package:monumento/components/categories/categories_home.dart';
import 'package:monumento/components/maps/maps_utils.dart';
import 'package:monumento/components/menu/menu_page.dart';
import 'package:monumento/home.dart';
import 'package:monumento/models/menu_item.dart';

class RuinsNavigator extends StatefulWidget {
  
  const RuinsNavigator({Key? key}) : super(key: key);

  @override
  State<RuinsNavigator> createState() => _RuinsNavigatorState();
}

class _RuinsNavigatorState extends State<RuinsNavigator> {
  MI currentItem = MenuItems.category;
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        slideWidth: MediaQuery.of(context).size.width * 0.77,
        showShadow: true,
        backgroundColor: Color.fromRGBO(251, 192, 45, 1),
        style: DrawerStyle.Style1,
        openCurve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        mainScreen: getScreen(),
        menuScreen: Builder(
          builder: (context) => MenuPage(
            currentItem: currentItem,
            onSelectedItem: (item) {
              if (item == MenuItems.rateUs){
                setState(() => currentItem = item);
                MapUtils.storeRedirection();
                ZoomDrawer.of(context)!.close();
              } else {
                setState(() => currentItem = item);
                ZoomDrawer.of(context)!.close();
              }
            },
          ),
        ),
      );
  }

  dynamic getScreen() {
    switch (currentItem) {
      case MenuItems.home:
        return Home();
      case MenuItems.map:
        return Home();
      case MenuItems.ar:
        return ArUs();
      case MenuItems.category:
        return HomeCategories();
      case MenuItems.rateUs:
        return Home();
      case MenuItems.update:
        return Home();
      case MenuItems.aboutUs:
        return Home();
    }
  }
}
