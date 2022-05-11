import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/constants/colors.dart';

class SuccessAlert extends StatelessWidget {

  
  String header;
  String title;
  String desc;
  SuccessAlert({
    Key? key,
    this.header = 'assets/animations/done.json',
    this.title = 'Login Succeed',
    this.desc = 'Welcome back, glad to see you here again',
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 260,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  Text(
                    title, 
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 24,
                      ),),
                  SizedBox(height: 10,),
                  Text(
                    desc,                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,),
                  SizedBox(height: 22,),
                  ElevatedButton(onPressed: () {
                    Navigator.of(context).pop();
                  },
                    style: ElevatedButton.styleFrom(
                      primary: AppColors.mainColor,
                      padding: EdgeInsets.all(16),
                      elevation: 8
                    ),
                    child: Text(
                      'Okay', 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20),),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: -50,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 55,
              child: Lottie.asset(
                header,
                fit: BoxFit.cover,
                repeat: false,
                ),
            )
          ),
        ],
      )
    );
  }
}