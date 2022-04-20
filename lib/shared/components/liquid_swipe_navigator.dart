// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:monumento/components/categories/buildCategoryPage.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/constants/monuments_description.dart';
import 'package:monumento/d_b_icons_icons.dart';
import 'package:monumento/shared/components/concaveCard.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/neumorphism.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Map<String, List<CategoryPage>> catPage = {
  'nord': [
    CategoryPage(
      country: 'carthage-amphi',
      region: 'north',
      image: 'assets/Categories/carthage.png',
      title: "L'amphithéâtre de Carthage",
      location: 'Carthage, Tunis',
      subtitle1: 'Dimensions externes',
      subtitle2: 'Dimensions de l’arène',
      subtitle3: 'Capacité',
      url: "https://fr.wikipedia.org/wiki/Amphithéâtre_de_Carthage",
    ),
    CategoryPage(
      country: 'aqueduc-zaghouan',
      region: 'north',
      image: 'assets/Categories/aqueduc.png',
      title: "L'aqueduc de Zaghouan",
      location: 'Zaghouan-Carthage',
      subtitle1: 'Longueur',
      subtitle2: 'Usage',
      subtitle3: 'Année début travaux',
    ),
  ],
  'centre': [
    CategoryPage(
      country: 'el-jem',
      region: 'middle',
      image: 'assets/Categories/el-jem.jpg',
      title: "L'amphithéâtre d'El Jem",
      location: 'El-Jem, Mahdia',
      subtitle1: 'Dimensions externes',
      subtitle2: 'Dimensions de l’arène',
      subtitle3: 'Capacité',
    ),
  ]
};

class LiquidSwipeNavigator extends StatefulWidget {
  final String? region;

  LiquidSwipeNavigator({Key? key, 
  required this.region}) : super(key: key);

  @override
  State<LiquidSwipeNavigator> createState() => _LiquidSwipeNavigatorState();
}

class _LiquidSwipeNavigatorState extends State<LiquidSwipeNavigator> {
  final controller = LiquidController();
  late final len = catPage[widget.region]?.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: 18,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 2),
          child: IconButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            icon: Icon(Icons.arrow_back),
            iconSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          LiquidSwipe(
            liquidController: controller,
            enableSideReveal: true,
            slideIconWidget: Icon(
              Icons.arrow_back_ios,
              color: Colors.pink,
            ),
            onPageChangeCallback: (int index) {
              setState(() {});
            },
            pages: [
              for (CategoryPage cat in catPage[widget.region]!)
                cat
            ],
          ),
          Positioned(
              bottom: 12,
              right: 16,
              left: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  neumorphicButton(
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(5)),
                      padding: EdgeInsets.only(right: 3, left: 3, bottom: 3),
                      prColor: grey300,
                      sdColor: grey300,
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                        ),
                        onPressed: () {
                          print(len);
                          final page = controller.currentPage - 1;
                          controller.animateToPage(
                              page: page < 0 ? len! - 1 : page, duration: 400);
                        },
                        child: Text(
                          'PREC',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  AnimatedSmoothIndicator(
                    activeIndex: controller.currentPage,
                    count: len!,
                    effect: WormEffect(
                        spacing: 15,
                        dotColor: grey300,
                        activeDotColor: Color.fromRGBO(117, 117, 117, 1)),
                    onDotClicked: (int index) {
                      controller.animateToPage(page: index);
                    },
                  ),
                  neumorphicButton(
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(5)),
                      padding: EdgeInsets.only(right: 3, left: 3, bottom: 3),
                      prColor: grey300,
                      sdColor: grey300,
                      child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                        ),
                        onPressed: () {
                          final page = controller.currentPage + 1;
                          controller.animateToPage(
                              page: page > len! ? 0 : page, duration: 400);
                        },
                        child: Text(
                          'SUIV',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                ],
              ))
        ],
      ),
    );
  }
}
