import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monumento/components/admin_dashboard/admin_ruins_navigator.dart';
import 'package:monumento/components/categories/categories_home.dart';
import 'package:monumento/components/categories/ruins_home_navigator.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class ArUs extends StatefulWidget {
  const ArUs({Key? key}) : super(key: key);

  @override
  State<ArUs> createState() => _ArUsState();
}

class _ArUsState extends State<ArUs> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget bottomBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8,
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: AppColors.mainColor.withOpacity(0.5),
        iconSize: 25,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.camera_alt_rounded,
              ),
              label: 'Camera'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_balance_rounded,
              ),
              label: 'Ruins'),
        ],
        currentIndex: 0,
        onTap: (int i) {
          if (i == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ArUs()));
          } else if (i == 2) {
            FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.email == 'admin-athar@gmail.com'
            ? Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AdminRuinsNavigator()))
            : Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => RuinsNavigator()));
            } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NavigationDrawer()));
          }
        },
      ),
    );
  }
}
