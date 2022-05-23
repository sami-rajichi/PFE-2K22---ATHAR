import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monumento/components/profile/body.dart';
import 'package:monumento/components/profile/edit_profile.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/bottomBar.dart';
import 'package:monumento/shared/components/navigation_drawer.dart';

class GalleryScreen extends StatefulWidget {
  final String image;
  final String name;
  final String gender;
  final String email;
  final String pass;
  const GalleryScreen({ 
    Key? key, 
    required this.image, 
    required this.name, 
    required this.gender, 
    required this.email, 
    required this.pass }) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {

  bool isPhoto = true;

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
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Gallery',
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
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: (){
                  setState(() {
                    isPhoto = true;
                  });
                }, 
                icon: Icon(
                  Icons.photo_rounded,
                  size: 30,
                  color: isPhoto ? AppColors.mainColor : AppColors.bigTextColor,
                )),
                IconButton(
                onPressed: (){
                  setState(() {
                    isPhoto = false;
                  });
                }, 
                icon: Icon(
                  Icons.video_collection,
                  size: 30,
                  color: !isPhoto ? AppColors.mainColor : AppColors.bigTextColor,
                ))
            ],
          )
        ],
      ),
    ),
      backgroundColor: AppColors.backgroundColor,
      // bottomNavigationBar: ConvexBottomBar(backgroundColor: AppColors.mainColor,),
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