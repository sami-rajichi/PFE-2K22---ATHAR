import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:monumento/components/admin_dashboard/admin_homepage.dart';
import 'package:monumento/components/admin_dashboard/admin_panel_menu.dart';
import 'package:monumento/components/ar/arUs.dart';
import 'package:monumento/components/categories/categories_home.dart';
import 'package:monumento/components/changelog/changelog.dart';
import 'package:monumento/components/maps/maps_utils.dart';
import 'package:monumento/components/menu/menu_page.dart';
import 'package:monumento/home.dart';
import 'package:monumento/models/menu_item.dart';

class AdminRuinsNavigator extends StatefulWidget {
  
  const AdminRuinsNavigator({Key? key}) : super(key: key);

  @override
  State<AdminRuinsNavigator> createState() => _AdminRuinsNavigatorState();
}

class _AdminRuinsNavigatorState extends State<AdminRuinsNavigator> {
  MI currentItem = AdminPanelMenu.category;
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
        slideWidth: MediaQuery.of(context).size.width * 0.77,
        showShadow: true,
        backgroundColor: Colors.white38,
        style: DrawerStyle.Style1,
        openCurve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 500),
        mainScreen: getScreen(),
        menuScreen: Builder(
          builder: (context) => AdminMenuPage(
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
      case AdminPanelMenu.dashboard:
        return AdminHomepage(uid: FirebaseAuth.instance.currentUser!.uid);
      case AdminPanelMenu.ar:
        return ArUs();
      case AdminPanelMenu.category:
        return HomeCategories();
      case AdminPanelMenu.update:
        return ChangeLogScreen();
    }
  }
}
