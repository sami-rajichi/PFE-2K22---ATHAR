import 'package:flutter/material.dart';
import 'package:monumento/components/ar/arUs.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/liquid_swipe_navigator.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

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
          elevation: 3,
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
            ],
          ),
        ),
        backgroundColor: Colors.white,
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
        currentIndex: 2,
        onTap: (int i) {
          if (i == 0) {
            Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (context) => ArUs()));
          } else if (i == 2) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeCategories()));
          }
          else {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NavigationDrawer()));
          }
        },
      ),
    );
  }
}