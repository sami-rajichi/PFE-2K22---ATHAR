import 'package:flutter/material.dart';
import 'package:monumento/constants/colors.dart';

class HowToUse extends StatefulWidget {
  const HowToUse({Key? key}) : super(key: key);

  @override
  State<HowToUse> createState() => _HowToUseState();
}

class _HowToUseState extends State<HowToUse> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            margin: EdgeInsets.only(top: 22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            padding: EdgeInsets.only(top: 35, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            child: Image.asset(
                              'assets/img/map.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            'AR Virtual Guide',
                            style: TextStyle(
                                fontSize: 18, color: AppColors.bigTextColor),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 140,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColors.mainColor)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: ListView(
                                          children: [
                                            Image.asset(
                                              'assets/img/1.1.png',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.9,
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                            ),
                                            Image.asset(
                                              'assets/img/1.2.png',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.9,
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/img/play-button.png',
                                    height: 18,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Play Me',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            child: Image.asset(
                              'assets/img/coliseum.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            'AR Reconstruction',
                            style: TextStyle(
                                fontSize: 18, color: AppColors.bigTextColor),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: 140,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColors.mainColor)),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: ListView(
                                          children: [
                                            Image.asset(
                                              'assets/img/1.1.png',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.9,
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                            ),
                                            Image.asset(
                                              'assets/img/2.2.png',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.9,
                                              width: double.infinity,
                                              fit: BoxFit.fill,
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/img/play-button.png',
                                    height: 18,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Play Me',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                'How To Use',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
