import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/components/profile/edit_profile.dart';
import 'package:monumento/components/profile/favorites.dart';
import 'package:monumento/components/profile/gallery.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class ProfileScreen extends StatefulWidget {
  String? image;
  String? name;
  String? gender;
  String? email;
  String? pass;
  ProfileScreen(
      {Key? key,
      required this.image,
      required this.name,
      required this.gender,
      required this.email,
      required this.pass})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                MaterialPageRoute(builder: (context) => NavigationDrawer()));
          },
        ),
        title: Text(
          'Profile',
          style: TextStyle(color: AppColors.bigTextColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 12,
            ),
            SizedBox(
              width: double.infinity,
            ),
            Stack(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProfile(
                            image: widget.image!,
                            name: widget.name!,
                            gender: widget.gender!,
                            email: widget.email!,
                            pass: widget.pass!)));
                  },
                  borderRadius: BorderRadius.circular(80),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 4, color: AppColors.backgroundColor),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10))
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: getImage())),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditProfile(
                              image: widget.image!,
                              name: widget.name!,
                              gender: widget.gender!,
                              email: widget.email!,
                              pass: widget.pass!,
                            )));
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: AppColors.mainColor,
                    ),
                    tileColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text('Account'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FavoritesScreen(
                              image: widget.image!,
                              name: widget.name!,
                              gender: widget.gender!,
                              email: widget.email!,
                              pass: widget.pass!,
                            )));
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: AppColors.mainColor,
                    ),
                    tileColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text('Favorites'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            saveAlert(FirebaseAuth.instance.currentUser!.uid));
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.delete,
                      color: AppColors.mainColor,
                    ),
                    tileColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text('Delete Account'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.mainColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () async {
                    final isLoggedInWithGoogle =
                        await GoogleSignIn().isSignedIn();
                    final fbLoggedIn = FacebookAuth.instance.accessToken;
                    if (isLoggedInWithGoogle) {
                      GoogleSignIn().disconnect();
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => NavigationDrawer()),
                          (route) => false);
                    } else if (fbLoggedIn != null) {
                      await FacebookAuth.instance.logOut();
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => NavigationDrawer()),
                          (route) => false);
                    } else {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => NavigationDrawer()),
                          (route) => false);
                    }
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.logout_rounded,
                      color: AppColors.mainColor,
                    ),
                    tileColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    title: Text('Log out'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.mainColor,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
    );
  }

  ImageProvider getImage() {
    if (widget.image == null) {
      return AssetImage('assets/img/avatar.png');
    } else if (widget.image!.startsWith('assets/')) {
      return AssetImage(widget.image!);
    } else if (widget.image!.startsWith('http')) {
      return NetworkImage(widget.image!);
    } else {
      return FileImage(File(widget.image!));
    }
  }

  Widget saveAlert(
    String uid,
  ) {
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
                      'Delete Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Would you really want to delete your account?',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.black45),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              primary: Colors.grey[600],
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 2.2,
                                  color: Colors.black87),
                            )),
                        ElevatedButton(
                          style: OutlinedButton.styleFrom(
                            primary: Colors.grey[600],
                            backgroundColor: AppColors.mainColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 12),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            delete(context, uid);
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => NavigationDrawer()));
                          },
                          child: Text(
                            "DELETE",
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        )
                      ],
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
                    'assets/animations/warning.json',
                    fit: BoxFit.cover,
                    repeat: false,
                  ),
                )),
          ],
        ));
  }

  Future delete(
    BuildContext context,
    String uid,
  ) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String u = uid;
    try {
      final user = _auth.currentUser;
      final isLoggedInWithGoogle = await GoogleSignIn().isSignedIn();
      final fbLoggedIn = FacebookAuth.instance.accessToken;
      if (isLoggedInWithGoogle) {
        await user!.delete();
        GoogleSignIn().disconnect();
        FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => NavigationDrawer()),
            (route) => false);
      } else if (fbLoggedIn != null) {
        await user!.delete();
        await FacebookAuth.instance.logOut();
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => NavigationDrawer()),
            (route) => false);
      } else {
        await user!.delete();
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => NavigationDrawer()),
            (route) => false);
      }
      await FirebaseFirestore.instance.collection('users').doc(u).delete();
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Account Deleted Successfully\n\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: 'Your account has been deleted from the system',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
        ])),
        backgroundColor: AppColors.mainColor,
        duration: Duration(seconds: 4),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Deletion Failed\n\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: '[' +
                  e.code.toString() +
                  ']:' +
                  e.toString().substring(e.toString().lastIndexOf(']') + 1),
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white)),
        ])),
        backgroundColor: AppColors.mainColor,
        duration: Duration(seconds: 4),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
