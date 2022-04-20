import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/d_b_icons_icons.dart';
import 'package:monumento/shared/components/bottomBar.dart';
import 'package:monumento/shared/components/menu_widget.dart';
import 'package:monumento/shared/components/neumorphism.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MenuWidget(),
        title: Text(
          'Monumento'
        ),
        // toolbarHeight: 65,
        backgroundColor: AppColors.mainColor,
        centerTitle: true,
      ),
      body: ListWheelScrollView(
        squeeze: 1.1,
        itemExtent: 500,
        physics: const FixedExtentScrollPhysics(),
        diameterRatio: 2.2,
        children: [
          buildCard(0),
          buildCard(1),
          buildCard(2),
          buildCard(3),
          buildCard(4),
          buildCard(5),
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: ConvexBottomBar(
        backgroundColor: AppColors.mainColor
      )
    );
  }

  buildCard(int i) => Center(
    child: Padding(
      padding: const EdgeInsets.all(40.0),
      child: Container(
        width: double.infinity,
        // height: 850,
        color: Colors.grey[400],
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'Item $i',
            style: TextStyle(
              fontSize: 50,
            ),
          ),
        )
      ),
    ),
  );
}