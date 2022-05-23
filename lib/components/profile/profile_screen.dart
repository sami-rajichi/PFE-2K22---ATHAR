import 'package:flutter/material.dart';
import 'package:monumento/components/profile/body.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class ProfileScreen extends StatelessWidget {
  final String image;
  final String name;
  final String gender;
  final String email;
  final String pass;
  const ProfileScreen({ 
    Key? key, 
    required this.image, 
    required this.name, 
    required this.gender, 
    required this.email, 
    required this.pass }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: BackButton(
          color: AppColors.bigTextColor,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NavigationDrawer())
            );
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: AppColors.bigTextColor
          ),
        ),
      ),
      body: Body(
        image: image,
        name: name,
        gender: gender,
        email: email,
        pass: pass,),
      backgroundColor: AppColors.backgroundColor,
    );
  }
}