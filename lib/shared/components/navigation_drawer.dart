// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:monumento/components/ar/arUs.dart';
import 'package:monumento/components/categories/buildCategoryPage.dart';
import 'package:monumento/components/categories/categories_home.dart';
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
        openCurve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        mainScreen: getScreen(),
        menuScreen: Builder(
          builder: (context) => MenuPage(
            currentItem: currentItem,
            onSelectedItem: (item) {
              setState(() => currentItem = item);
              ZoomDrawer.of(context)!.close();
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
      case MenuItems.help:
        return Home();
      case MenuItems.update:
        return Home();
      case MenuItems.aboutUs:
        return Home();
    }
  }
}
