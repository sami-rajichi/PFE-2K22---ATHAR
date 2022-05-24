import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  ProfileScreen({ 
    Key? key, 
    required this.image, 
    required this.name, 
    required this.gender, 
    required this.email, 
    required this.pass }) : super(key: key);

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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GalleryScreen(
                            image: widget.image!,
                            name: widget.name!,
                            gender: widget.gender!,
                            email: widget.email!,
                            pass: widget.pass!,
                          )));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.photo_album,
                    color: AppColors.mainColor,
                  ),
                  tileColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text('Gallery'),
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
    backgroundColor: AppColors.backgroundColor,);
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
}