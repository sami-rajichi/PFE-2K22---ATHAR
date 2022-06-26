import 'package:flutter/material.dart';
import 'package:monumento/constants/colors.dart';
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
    "el jem vector.png",
    "Zaghouan_aqueduc vector.png",
    "matmata vector.png",
  ];
  List features = [
    "Because the 3D Visualization feature",
    "Because the AR Reconstruction feature",
    "Because the AR Virtual Guide feature",
  ];
  List descriptions = [
    "Let's you discover the 3D presentations of the archeological sites",
    "Let's you immerse the 3D models into the real environment, and gives the illusion of a perfect integration to you",
    "Let's you unleash the experience up a notch with the new way of presenting the tourism guide",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          scrollDirection: Axis.vertical,
          itemCount: images.length,
          itemBuilder: (_, index) {
            return Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 150, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLargeText(text: "Explore ATHAR"),
                          SizedBox(height: 12),
                          AppText(
                            text: features[index],
                            size: 19,
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: 250,
                            child: Text(
                              descriptions[index],
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 15.5,
                                  color:
                                      AppColors.bigTextColor.withOpacity(0.6)),
                            ),
                          ),
                          SizedBox(height: 40),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          NavigationDrawer()));
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
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: index == 0
                    ? 430
                    : index == 1 ? 395 : 435,
                    child: Image.asset(
                      "assets/img/" + images[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }
}
