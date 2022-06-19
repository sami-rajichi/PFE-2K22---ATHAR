import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monumento/components/admin_dashboard/admin_navigator.dart';
import 'package:monumento/components/admin_dashboard/admin_ruins_navigator.dart';
import 'package:monumento/components/admin_dashboard/monuments/manage_monuments.dart';
import 'package:monumento/components/ar/arUs.dart';
import 'package:monumento/components/categories/ruins_home_navigator.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/liquid_swipe_navigator.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class MonumentsHomepage extends StatefulWidget {
  const MonumentsHomepage({Key? key}) : super(key: key);

  @override
  State<MonumentsHomepage> createState() => _MonumentsHomepageState();
}

class _MonumentsHomepageState extends State<MonumentsHomepage> {
  List<String> monuments = ['North', 'Central', 'Sud'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (() => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AdminNavigator()))),
          color: AppColors.bigTextColor,
        ),
        title: Text(
          'Monuments',
          style: TextStyle(color: AppColors.bigTextColor),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 65),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/ruins.png',
              height: 230,
              width: 230,
            ),
            SizedBox(
              height: 35,
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: monuments.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 22.0),
                    child: InkWell(
                      onTap: () {
                        String region = '';
                        switch (index) {
                          case 0:
                            region = 'north';
                            break;
                          case 1:
                            region = 'central';
                            break;
                          case 2:
                            region = 'sud';
                            break;
                          default: region = 'central';
                        }
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ManageMonuments(
                                region: region)));
                      },
                      child: Material(
                        elevation: 8,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          leading: Icon(
                            Icons.account_balance_rounded,
                            color: AppColors.mainColor,
                          ),
                          title: Text(monuments[index] + ' Monuments'),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          tileColor: Colors.white,
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.mainColor,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
