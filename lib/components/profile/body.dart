import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monumento/components/profile/edit_profile.dart';
import 'package:monumento/components/profile/favorites.dart';
import 'package:monumento/components/profile/gallery.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class Body extends StatefulWidget {
  final String image;
  final String name;
  final String gender;
  final String email;
  final String pass;
  Body({ Key? key, 
  required this.image, 
    required this.name, 
    required this.gender, 
    required this.email, 
    required this.pass }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 12,),
          SizedBox(width: double.infinity,),
          Stack(
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context)
                      .push(MaterialPageRoute(
                        builder: (context) => EditProfile(
                          image: widget.image, 
                          name: widget.name, 
                          gender: widget.gender, 
                          email: widget.email, 
                          pass: widget.pass)));
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
          SizedBox(height: 60,),
          Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProfile(
                        image: widget.image,
                            name: widget.name,
                            gender: widget.gender,
                            email: widget.email,
                            pass: widget.pass,))
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.person, color: AppColors.mainColor,),
                  tileColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text('Account'),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.mainColor,),
                ),
              ),
              SizedBox(height: 16,),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FavoritesScreen(
                        image: widget.image,
                            name: widget.name,
                            gender: widget.gender,
                            email: widget.email,
                            pass: widget.pass,))
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.favorite, color: AppColors.mainColor,),
                  tileColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text('Favorites'),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.mainColor,),
                ),
              ),
              SizedBox(height: 16,),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GalleryScreen(
                        image: widget.image,
                            name: widget.name,
                            gender: widget.gender,
                            email: widget.email,
                            pass: widget.pass,))
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.photo_album, color: AppColors.mainColor,),
                  tileColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text('Gallery'),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.mainColor,),
                ),
              ),
              SizedBox(height: 16,),
              InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => NavigationDrawer()),
                      (route) => false);
                },
                child: ListTile(
                  leading: Icon(Icons.logout_rounded, color: AppColors.mainColor,),
                  tileColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text('Log out'),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.mainColor,),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  ImageProvider getImage() {
    if (widget.image == null) {
      return AssetImage('assets/img/avatar.png');
    } else if (widget.image.startsWith('assets/')) {
      return AssetImage(widget.image);
    } else if (widget.image.startsWith('http')){
      return NetworkImage(widget.image);
    } else {
      return FileImage(File(widget.image));
    }
  }
}