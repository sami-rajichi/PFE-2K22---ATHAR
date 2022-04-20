import 'package:flutter/material.dart';
import 'package:monumento/constants/colors.dart';

class ResponsiveButton extends StatelessWidget {
  bool? isResponsive;
  double? width;

  ResponsiveButton({Key? key, this.isResponsive = false, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.mainColor,
          ),
          child: Image.asset(
            "assets/img/right-arrows.png",
            width: 30,
            height: 15,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
