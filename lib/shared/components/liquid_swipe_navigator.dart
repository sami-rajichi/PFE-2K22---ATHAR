// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:monumento/components/categories/buildCategoryPage.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/d_b_icons_icons.dart';
import 'package:monumento/models/monuments.dart';
import 'package:monumento/network/firebaseServices.dart';
import 'package:monumento/shared/components/concaveCard.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/neumorphism.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LiquidSwipeNavigator extends StatefulWidget {
  final String? region;

  LiquidSwipeNavigator({Key? key, required this.region}) : super(key: key);

  @override
  State<LiquidSwipeNavigator> createState() => _LiquidSwipeNavigatorState();
}

class _LiquidSwipeNavigatorState extends State<LiquidSwipeNavigator> {
  final controller = LiquidController();
  FirebaseServices firebaseServices = new FirebaseServices();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          icon: Icon(Icons.arrow_back),
          iconSize: 20,
          color: Colors.black,
        ),
      ),
      body: StreamBuilder<List<Monument>>(
          stream: firebaseServices.getMonuments(widget.region!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {
              final monuments = snapshot.data!;
              final count = monuments.length;
              return Stack(
                children: [
                  LiquidSwipe(
                    liquidController: controller,
                    enableSideReveal: true,
                    slideIconWidget: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.pink,
                    ),
                    onPageChangeCallback: (int index) {
                      setState(() {
                      });
                    },
                    pages: [
                      for (var i = 0; i < count; i++)
                        CategoryPage(
                          name: monuments[i].name,
                          image: monuments[i].image,
                          location: monuments[i].location,
                          subtitle1: monuments[i].subtitle1,
                          subtitle1Value: monuments[i].subtitle1Value,
                          subtitle2: monuments[i].subtitle2,
                          subtitle2Value: monuments[i].subtitle2Value,
                          subtitle3: monuments[i].subtitle3,
                          subtitle3Value: monuments[i].subtitle3Value,
                          info: monuments[i].info,
                          url: monuments[i].url,
                          color: Colors.grey[400]!.withOpacity(0.2),
                        )
                    ],
                  ),
                  Positioned(
                      bottom: 12,
                      right: 16,
                      left: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(
                                    AppColors.overlay.withOpacity(0.3)),
                              ),
                              onPressed: () {
                                final page = controller.currentPage - 1;
                                controller.animateToPage(
                                    page: page < 0 ? count - 1 : page,
                                    duration: 400);
                              },
                              child: Text(
                                'PREC',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: AppColors.bigTextColor,
                                ),
                              )),
                          AnimatedSmoothIndicator(
                            activeIndex: controller.currentPage,
                            count: count,
                            effect: WormEffect(
                                dotWidth: 12,
                                type: WormType.thin,
                                dotHeight: 12,
                                spacing: 8,
                                dotColor: Colors.black26,
                                activeDotColor:
                                    AppColors.bigTextColor.withOpacity(0.8)),
                            onDotClicked: (int index) {
                              controller.animateToPage(page: index);
                            },
                          ),
                          TextButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all<Color>(
                                    AppColors.overlay.withOpacity(0.3)),
                              ),
                              onPressed: () {
                                final page = controller.currentPage + 1;
                                controller.animateToPage(
                                    page: page > count ? 0 : page,
                                    duration: 400);
                              },
                              child: Text(
                                'SUIV',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: AppColors.bigTextColor,
                                ),
                              ))
                        ],
                      ))
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
