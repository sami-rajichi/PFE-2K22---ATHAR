import 'package:carousel_slider/carousel_slider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:monumento/components/homepage/how_to_use.dart';
import 'package:monumento/components/homepage/reviews.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/d_b_icons_icons.dart';
import 'package:monumento/shared/components/bottomBar.dart';
import 'package:monumento/shared/components/getAvatar.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/neumorphism.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return FirebaseAuth.instance.currentUser == null
          ? notLoggedIn()
          : loggedIn();
  }

  Widget buildImage(String image, int index) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(300)),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
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

  Widget loggedIn() {
    final user = FirebaseAuth.instance.currentUser!;
      return Scaffold(
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
                  GetAvatar(img: 'assets/img/avatar.png', loggedIn: true,)
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
                    Reviews(),
                    Text(
                      user.email!,
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: Text(
                        'sign out'
                      ))
                  ],
                ),
              )
            ],
          ),
          backgroundColor: AppColors.backgroundColor,
          bottomNavigationBar:
              ConvexBottomBar(backgroundColor: AppColors.mainColor));
  }

  Widget notLoggedIn() {
    return Scaffold(
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
                GetAvatar(img: 'assets/img/avatar.png', loggedIn: false,),
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
                  Reviews(),
                  // Text(
                  //   user.email!,
                  //   style: TextStyle(
                  //     fontSize: 20
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () => FirebaseAuth.instance.signOut(),
                  //   child: Text(
                  //     'sign out'
                  //   ))
                ],
              ),
            )
          ],
        ),
        backgroundColor: AppColors.backgroundColor,
        bottomNavigationBar:
            ConvexBottomBar(backgroundColor: AppColors.mainColor)
    );
  }
}
