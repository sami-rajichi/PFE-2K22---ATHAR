import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monumento/components/profile/edit_profile.dart';
import 'package:monumento/components/profile/profile_screen.dart';
import 'package:monumento/components/profile/specific_monument.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/shared/components/bottomBar.dart';

class FavoritesScreen extends StatefulWidget {
  final String image;
  final String name;
  final String gender;
  final String email;
  final String pass;
  FavoritesScreen(
      {Key? key,
      required this.image,
      required this.name,
      required this.gender,
      required this.email,
      required this.pass})
      : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var d = snapshot.data as DocumentSnapshot;
            List favorites = d['liked-monuments'];
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Favorites',
                  style: TextStyle(color: AppColors.bigTextColor),
                ),
                centerTitle: true,
                leading: BackButton(
                  color: AppColors.bigTextColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            image: widget.image,
                            name: widget.name,
                            gender: widget.gender,
                            email: widget.email,
                            pass: widget.pass)));
                  },
                ),
              ),
              body: Container(
                padding: EdgeInsets.only(left: 20, top: 30, right: 20),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditProfile(
                                      image: widget.image,
                                      name: widget.name,
                                      gender: widget.gender,
                                      email: widget.email,
                                      pass: widget.pass)));
                            },
                            borderRadius: BorderRadius.circular(80),
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 4,
                                      color: AppColors.backgroundColor),
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
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height -390,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final item = favorites[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 18.0),
                              child: Dismissible(
                                key: UniqueKey(),
                                background: Card(color: AppColors.mainColor),
                                onDismissed: (DismissDirection direction) {
                                  delete(
                                      context,
                                      uid,
                                      favorites[index]['image'],
                                      favorites[index]['name'],
                                      favorites[index]['location'],
                                      favorites[index]['region']);
                                },
                                child: InkWell(
                                  onTap: () {
                                    print(index);
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SpecificMonument(
                                          index: index,
                                          region: favorites[index]['region'], 
                                          specificMonument: true,
                                        )
                                      )
                                    );
                                    print(index);
                                  },
                                  child: Material(
                                    elevation: 8,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    child: ListTile(
                                      key: ObjectKey(item),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(90),
                                        child: Image.asset(
                                          favorites[index]['image'],
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      title: Text(favorites[index]['name']),
                                      subtitle:
                                          Text(favorites[index]['location']),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 8),
                                      tileColor: Colors.white,
                                      trailing: IconButton(
                                        onPressed: () {
                                          delete(
                                              context,
                                              uid,
                                              favorites[index]['image'],
                                              favorites[index]['name'],
                                              favorites[index]['location'],
                                              favorites[index]['region']);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: AppColors.mainColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
              backgroundColor: AppColors.backgroundColor,
              bottomNavigationBar: ConvexBottomBar(
                backgroundColor: AppColors.mainColor,
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
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

  Future delete(BuildContext context, String uid, String image, String name,
      String location, String region) async {
    try {
      var data = [
        {
          'image': image,
          'location': location,
          'name': name,
          'region': region,
        }
      ];
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'liked-monuments': FieldValue.arrayRemove(data)});
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'Update Failed\n\n',
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
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 4),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
