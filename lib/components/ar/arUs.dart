import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monumento/components/ar/AR_camera_navigator.dart';
import 'package:monumento/components/categories/categories_home.dart';
import 'package:monumento/components/categories/ruins_home_navigator.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';
import 'package:monumento/shared/components/not_logged_in.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return NotLoggedInPage(pageTitle: 'AR Camera');
    } else {
      return loggedIn();
    }
  }

  Widget loggedIn() {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: MenuWidget(
          color: AppColors.mainColor,
        ),
        title: Text(
          'AR Camera',
          style: TextStyle(color: AppColors.mainColor),
        ),
        elevation: 3,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Hero(
                tag: 'roadmap',
                child: Container(
                    width: 320,
                    height: size.height * 0.28,
                    child: Image.asset(
                      'assets/img/roadmap.png',
                      fit: BoxFit.cover,
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FloatingActionButton.extended(
                        heroTag: 'btn1',
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        onPressed: () async {
                          List<Application> apps =
                              await DeviceApps.getInstalledApplications();
                          for (Application app in apps) {
                            print(app.packageName + '\n');
                          }
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const RoadmapScreen();
                          }));
                        },
                        label: Text('AR Virtual Guide')),
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: FloatingActionButton.extended(
                        heroTag: 'btn2',
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const RuinScreen();
                          }));
                        },
                        label: Text('AR Reconstruction')),
                  )
                ],
              ),
              Hero(
                tag: 'ruin',
                child: Container(
                    width: 320,
                    height: size.height * 0.30,
                    child: Image.asset(
                      'assets/img/ruin.png',
                      fit: BoxFit.cover,
                    )),
              )
            ],
          ),
        ),
      ),
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
              label: 'AR Camera'),
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
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ARcameraNavigator()));
          } else if (i == 2) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => RuinsNavigator()));
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NavigationDrawer()));
          }
        },
      ),
    );
  }
}

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({Key? key}) : super(key: key);

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 2200), (() {
      DeviceApps.openApp('com.DefaultCompany.CustomRoutes');
      Navigator.pop(context);
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            Hero(
              tag: 'roadmap2',
              child: Container(
                  width: 320,
                  height: size.height * 0.35,
                  child: Image.asset(
                    'assets/img/roadmap.png',
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            LinearPercentIndicator(
              width: size.width,
              animation: true,
              lineHeight: 22.0,
              animationDuration: 2000,
              percent: 1,
              barRadius: Radius.circular(8),
              progressColor: AppColors.mainColor,
            ),
          ],
        ),
      ),
    );
  }
}

class RuinScreen extends StatefulWidget {
  const RuinScreen({Key? key}) : super(key: key);

  @override
  State<RuinScreen> createState() => _RuinScreenState();
}

class _RuinScreenState extends State<RuinScreen> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 2200), (() {
      DeviceApps.openApp('com.DefaultCompany.gps');
      Navigator.pop(context);
    }));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            Hero(
              tag: 'ruin2',
              child: Container(
                  width: 320,
                  height: size.height * 0.35,
                  child: Image.asset(
                    'assets/img/ruin.png',
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              height: 40,
            ),
            LinearPercentIndicator(
              width: size.width,
              animation: true,
              lineHeight: 22.0,
              animationDuration: 2000,
              percent: 1,
              barRadius: Radius.circular(8),
              progressColor: Colors.brown[300],
            ),
          ],
        ),
      ),
    );
  }
}
