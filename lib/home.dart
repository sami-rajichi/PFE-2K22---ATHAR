import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:monumento/components/admin_dashboard/admin_homepage.dart';
import 'package:monumento/components/admin_dashboard/admin_navigator.dart';
import 'package:monumento/components/admin_dashboard/admin_ruins_navigator.dart';
import 'package:monumento/components/ar/arUs.dart';
import 'package:monumento/components/categories/categories_home.dart';
import 'package:monumento/components/categories/ruins_home_navigator.dart';
import 'package:monumento/components/homepage/how_to_use.dart';
import 'package:monumento/components/homepage/reviews.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/getAvatar.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool appBar = true;
  ScrollController _scrollController = new ScrollController();
  int activeIndex = 0;
  final List<String> images = [
    'assets/Categories/el-jem.jpg',
    'assets/Categories/carthage.png',
    'assets/Categories/bulla-regia.jpg',
    'assets/Categories/mos-espa.jpg',
    'assets/Categories/ribat-monastir.jpg',
    'assets/Categories/ksar-lemsa.jpg',
    'assets/Categories/aqueduc.png',
    'assets/Categories/dougga.jpg',
    'assets/Categories/gigthis.jpg',
    'assets/Categories/haidra.jpg',
    'assets/Categories/kerkouane.jpg',
    'assets/Categories/ksar-ouled-soltan.jpg',
    'assets/Categories/matmata.jpg',
    'assets/Categories/musee-sousse.jpg',
    'assets/Categories/kasbah.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      changeColor();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void changeColor() {
    if (_scrollController.offset >= 242) {
      setState(() {
        appBar = false;
      });
    } else {
      setState(() {
        appBar = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return notLoggedIn();
    } else {
      var uid = auth.currentUser!.uid;
      if (auth.currentUser!.email == 'admin-athar@gmail.com') {
        return AdminNavigator();
      } else {
        return loggedIn(uid, auth.currentUser!);
      }
    }
  }

  Widget buildImage(String image, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(300)),
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildIndicator() {
    return Container(
      margin: EdgeInsets.only(bottom: 6, left: 20),
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: images.length,
        effect: ScrollingDotsEffect(
            dotWidth: 12,
            dotHeight: 12,
            activeDotColor: AppColors.mainColor,
            dotColor: Colors.black26),
      ),
    );
  }

  Widget loggedIn(String uid, User user) {
    return Scaffold(
      extendBody: true,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Something went wrong !');
            } else if (snapshot.hasData) {
              var d = snapshot.data as DocumentSnapshot;
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    elevation: !appBar ? 6 : 0,
                    title: !appBar
                        ? Text(
                            'Athar',
                            style: TextStyle(color: AppColors.mainColor),
                          )
                        : Text(''),
                    centerTitle: true,
                    actions: [
                      GetAvatar(
                        img: d['image'],
                        name: d['name'],
                        gender: d['gender'],
                        email: d['email'],
                        pass: d['password'],
                        loggedIn: true,
                      )
                    ],
                    leading: !appBar
                        ? MenuWidget(
                            color: AppColors.mainColor,
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 8, left: 8),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: MenuWidget(
                              color: AppColors.mainColor,
                            )),
                    backgroundColor:
                        appBar ? AppColors.backgroundColor : Colors.white,
                    expandedHeight: 350,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          CarouselSlider.builder(
                            options: CarouselOptions(
                              height: 400,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 2),
                              viewportFraction: 1,
                              onPageChanged: (index, reason) {
                                setState(() => activeIndex = index);
                              },
                            ),
                            itemCount: images.length,
                            itemBuilder: (context, index, realIndex) {
                              final img = images[index];
                              return buildImage(img, index);
                            },
                          ),
                          buildIndicator()
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        HowToUse(),
                        ReviewsScreen(),
                        Text(
                          user.email!,
                          style: TextStyle(fontSize: 20),
                        ),
                        ElevatedButton(
                            onPressed: () => FirebaseAuth.instance.signOut(),
                            child: Text('sign out'))
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      backgroundColor: AppColors.backgroundColor,
      bottomNavigationBar: bottomBar(),
    );
  }

  Widget notLoggedIn() {
    return Scaffold(
      extendBody: true,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            elevation: 0,
            title: !appBar ? Text('Athar') : Text(''),
            actions: [
              GetAvatar(
                img: 'assets/img/avatar.png',
                loggedIn: false,
              ),
            ],
            leading: !appBar
                ? MenuWidget()
                : Container(
                    margin: EdgeInsets.only(top: 8, left: 8),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: MenuWidget(
                      color: AppColors.mainColor,
                    )),
            backgroundColor:
                appBar ? AppColors.backgroundColor : AppColors.mainColor,
            expandedHeight: 350,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      height: 400,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 2),
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() => activeIndex = index);
                      },
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index, realIndex) {
                      final img = images[index];
                      return buildImage(img, index);
                    },
                  ),
                  buildIndicator()
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                HowToUse(),
                ReviewsScreen(),
                SizedBox(height: 66,)
              ],
            ),
          )
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
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
        currentIndex: 1,
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
