import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/components/admin_dashboard/admin_navigator.dart';
import 'package:monumento/components/profile/profile_screen.dart';
import 'package:monumento/constants/colors.dart';

class UpdatedAlert extends StatelessWidget {
  final String image;
  final String name;
  final String gender;
  final String email;
  final String pass;
  String header;
  String title;
  String desc;
  UpdatedAlert(
      {Key? key,
      this.header = 'assets/animations/done.json',
      this.title = 'Login Succeed',
      this.desc = 'Welcome back, glad to see you here again',
      required this.image,
      required this.name,
      required this.gender,
      required this.email,
      required this.pass})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 240,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 65, 10, 10),
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      desc,
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.currentUser != null &&
                                FirebaseAuth.instance.currentUser!.email ==
                                    'admin-athar@gmail.com'
                            ? Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AdminNavigator()))
                            : Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    image: image,
                                    name: name,
                                    gender: gender,
                                    email: email,
                                    pass: pass)));
                      },
                      style: ElevatedButton.styleFrom(
                          primary: AppColors.mainColor,
                          padding: EdgeInsets.all(12),
                          elevation: 4),
                      child: Text(
                        'Okay',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -35,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: Lottie.asset(
                    header,
                    fit: BoxFit.cover,
                    repeat: false,
                  ),
                )),
          ],
        ));
  }
}
