import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:monumento/components/menu/menu_page.dart';
import 'package:monumento/home.dart';
import 'package:monumento/models/menu_item.dart';
import 'package:monumento/shared/components/liquid_swipe_navigator.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  MenuItem currentItem = MenuItems.home;
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        slideWidth: MediaQuery.of(context).size.width * 0.77,
        angle: -8,
        showShadow: true,
        backgroundColor: Color.fromRGBO(251, 192, 45, 1),
        style: DrawerStyle.Style1,
        menuScreen: Builder(
          builder: (context) => MenuPage(
            currentItem: currentItem,
            onSelectedItem: (item) {
              setState(() {
                currentItem = item;
                ZoomDrawer.of(context)!.close();
              });
            },
          ),
        ),
        mainScreen: getItem());
  }

  getItem() {
    switch (currentItem) {
      case MenuItems.home:
        return Home();
        break;
      case MenuItems.map:
        return Home();
        break;
      case MenuItems.ar:
        return Home();
        break;
      case MenuItems.category:
        return LiquidSwipeNavigator();
        break;
      case MenuItems.help:
        return Home();
        break;
      case MenuItems.update:
        return Home();
        break;
      case MenuItems.aboutUs:
        return Home();
        break;
    }
  }
}
