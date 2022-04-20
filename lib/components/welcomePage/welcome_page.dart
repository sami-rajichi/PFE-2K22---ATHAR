import 'package:flutter/material.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/home.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';
import 'package:monumento/shared/components/widgets/app_large_text.dart';
import 'package:monumento/shared/components/widgets/app_text.dart';
import 'package:monumento/shared/components/widgets/responsive_button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List images = [
    "eljem_splash_1.png",
    "eljem_splash_1.png",
    "eljem_splash_1.png",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index) {
            return Container(
              height: double.maxFinite,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/img/" + images[index],
                      ),
                      fit: BoxFit.fill)),
              child: Container(
                margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppLargeText(text: "Welcome"),
                        SizedBox(height: 5),
                        AppText(
                          text: "To Monumento",
                          size: 30,
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: 250,
                          child: AppText(
                            text:
                                "reconstruction photogrammétrique 3D, simplification 3D, visualisation AR. La base de connaissances applicable aux sites archéologiques est également décrite ici.",
                            size: 15.5,
                          ),
                        ),
                        SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => NavigationDrawer()));
                          },
                          child: ResponsiveButton(
                            width: 120,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: List.generate(
                        images.length,
                        (indexDots) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 5),
                            width: 8,
                            height: index == indexDots ? 25 : 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: index == indexDots
                                  ? AppColors.mainColor
                                  : AppColors.mainColor.withOpacity(0.5),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
