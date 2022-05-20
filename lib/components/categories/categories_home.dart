import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/bottomBar.dart';
import 'package:monumento/shared/components/liquid_swipe_navigator.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({Key? key}) : super(key: key);

  @override
  State<HomeCategories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  List<String> monuments = ['North', 'Central', 'Sud'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: MenuWidget(
            color: AppColors.mainColor,
          ),
          title: Text(
            'Monumento',
            style: TextStyle(color: AppColors.mainColor),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0, vertical: 65),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/ruins.png',
                height: 230,
                width: 230,
              ),
              SizedBox(height: 30,),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: monuments.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => 
                              LiquidSwipeNavigator(region: monuments[index].toLowerCase().trim())
                            )
                          );
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
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
              // GestureDetector(
              //   child: regionButton('North Monuments'),
              //   onTap: () {
              //     setState(() {
              //       isPressed = !isPressed;
              //     });
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) =>
              //                 LiquidSwipeNavigator(region: 'north')));
              //   },
              // ),
              // SizedBox(
              //   height: 35,
              // ),
              // regionButton(
              //   'Central Monuments',
              // ),
              // SizedBox(
              //   height: 35,
              // ),
              // regionButton(
              //   'Sud Monuments',
              // ),
              // SizedBox(
              //   height: 15,
              // ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: ConvexBottomBar(
          backgroundColor: AppColors.mainColor,
        ));
  }

  
}