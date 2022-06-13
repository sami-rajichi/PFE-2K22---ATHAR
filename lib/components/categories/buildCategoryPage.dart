import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:monumento/components/ar/ar_models.dart';
import 'package:monumento/components/maps/maps_utils.dart';
import 'package:monumento/components/profile/favorites.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/d_b_icons_icons.dart';
import 'package:monumento/shared/components/concaveCard.dart';
import 'package:monumento/shared/components/description.dart';
import 'package:monumento/shared/components/neumorphic_image.dart';
import 'package:monumento/shared/components/neumorphism.dart';
import 'package:monumento/shared/components/success_alert.dart';
import 'package:collection/collection.dart';

class CategoryPage extends StatefulWidget {
  final String? name;
  final String? info;
  final String? location;
  final String? image;
  final String? region;
  final String? country;
  final Color? color;
  final Color? backgroundColor;
  final String? url;
  final bool? fromListView;

  CategoryPage({
    Key? key,
    this.name,
    this.location,
    this.image,
    this.region,
    this.country,
    this.color = Colors.white,
    this.backgroundColor = Colors.white,
    this.url,
    this.info,
    this.fromListView,
  }) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return notLoggedIn();
    } else {
      var uid = auth.currentUser!.uid;
      return loggedIn(uid);
    }
  }

  Widget notLoggedIn() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.name!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lobster(
                        fontSize: 25, color: AppColors.bigTextColor)),
                SizedBox(
                  height: 25,
                ),
                Flexible(
                  child: neumorphicImage(
                      color: Colors.grey[400],
                      image: Image(
                        image: AssetImage(widget.image!),
                        fit: BoxFit.fill,
                        height: 250,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: neumorphicCard(
                          color: widget.color,
                          child: description(
                            subtitle: 'Location: ',
                            text: widget.location!,
                          )),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    neumorphicButton(
                      prColor: widget.color,
                      sdColor: widget.color,
                      depth: 15,
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.pink,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                neumorphicCard(
                    color: widget.color,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        Container(
                          width: 600,
                          child: description(
                            subtitle: 'Description:\n',
                            text: widget.info!,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        getButtons(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 39,
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget loggedIn(String uid) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var d = snapshot.data as DocumentSnapshot;
              Icon data = addToFavorite(d);
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(widget.name!,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lobster(
                                fontSize: 25, color: AppColors.bigTextColor)),
                        SizedBox(
                          height: 25,
                        ),
                        Flexible(
                          child: neumorphicImage(
                              color: Colors.grey[400],
                              image: Image(
                                image: AssetImage(widget.image!),
                                fit: BoxFit.fill,
                                height: 250,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: neumorphicCard(
                                  color: widget.color,
                                  child: description(
                                    subtitle: 'Location: ',
                                    text: widget.location!,
                                  )),
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            neumorphicButton(
                              prColor: widget.color,
                              sdColor: widget.color,
                              depth: 15,
                              child: InkWell(
                                  onTap: () {
                                    update(context);
                                  },
                                  child: data),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        neumorphicCard(
                            color: widget.color,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 600,
                                  child: description(
                                    subtitle: 'Description:\n',
                                    text: widget.info!,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                getButtons(),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 39,
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
      backgroundColor: Colors.white,
    );
  }

  Widget getButtons() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.article,
                    color: AppColors.mainColor,
                    size: 16,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.mainColor),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    primary: Colors.grey[600],
                  ),
                  onPressed: () {
                    MapUtils.openReadMore(widget.url!);
                  },
                  label: Text(
                    'READ MORE',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 2.2,
                        color: AppColors.mainColor),
                  )),
            ),
            SizedBox(
              width: 14,
            ),
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(
                  Icons.location_on,
                  color: AppColors.mainColor,
                  size: 16,
                ),
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.mainColor),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    primary: Colors.grey[600],
                  ),
                onPressed: () {
                  MapUtils.openMap(widget.name!);
                },
                label: Text(
                  "SHOW IN MAP",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12, letterSpacing: 2.2, color: AppColors.mainColor),
                ),
              ),
            )
          ],
        ),
        ElevatedButton.icon(
            icon: Icon(
              Icons.threed_rotation,
              color: Colors.white,
              size: 16,
            ),
            style: ElevatedButton.styleFrom(
                side: BorderSide(color: AppColors.mainColor),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                primary: AppColors.mainColor,
              ),
            onPressed: () async {
              final model = await getModel();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) =>
                  ARModels(monumentName: widget.name, models: model))
              );
            },
            label: Text(
              "3D VIEW MODE",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12, letterSpacing: 2.2, color: Colors.white),
            ),
          )
      ],
    );
  }

  Future<String> getModel() async {
    final doc = await FirebaseFirestore.instance
                      .collection('ar_models')
                      .doc('ar_models').get();
    final data = doc.data();
    List models = doc['ar_models'];
    String model = '';
    for (var i = 0; i < models.length; i++){
      if (models[i]['name'] == widget.name){
        model = models[i]['models'];
        break;
      }
    }
    return model;
  }

  Icon addToFavorite(DocumentSnapshot doc) {
    var data = [
      {
        'image': widget.image,
        'location': widget.location,
        'name': widget.name,
        'region': widget.region,
      }
    ];
    List likes = doc['liked-monuments'];
    if (likes.any(
        (element) => DeepCollectionEquality().equals(element, data.first))) {
      return Icon(
        Icons.favorite,
        color: Colors.pink,
      );
    } else {
      return Icon(
        Icons.favorite_border,
        color: Colors.pink,
      );
    }
  }

  Future update(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      String uid = auth.currentUser!.uid.toString();
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      var data = [
        {
          'image': widget.image,
          'location': widget.location,
          'name': widget.name,
          'region': widget.region,
        }
      ];

      DocumentSnapshot documentSnapshot = await docRef.get();
      List likes = documentSnapshot['liked-monuments'];
      if (!likes.any(
          (element) => DeepCollectionEquality().equals(element, data.first))) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'liked-monuments': FieldValue.arrayUnion(data)});
        final update = SnackBar(
          content: RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: 'Monument Added\n\n',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            TextSpan(
                text: '${widget.name} has been added to favorites',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white)),
          ])),
          backgroundColor: AppColors.mainColor,
          duration: Duration(seconds: 2),
          // shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(update);
      } else {
        if (widget.fromListView == false) {
          final remove = SnackBar(
            content: RichText(
                text: TextSpan(children: [
              const TextSpan(
                  text: 'Monument Removed\n\n',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              TextSpan(
                  text: '${widget.name} has been removed from favorites',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: Colors.white)),
            ])),
            backgroundColor: AppColors.mainColor,
            duration: Duration(seconds: 2),
            // shape: StadiumBorder(),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(remove);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'liked-monuments': FieldValue.arrayRemove(data)});
        } else {
          try {
            final remove = SnackBar(
              content: RichText(
                  text: TextSpan(children: [
                const TextSpan(
                    text: 'Monument Removed\n\n',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                TextSpan(
                    text: '${widget.name} has been removed from favorites',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white)),
              ])),
              backgroundColor: AppColors.mainColor,
              duration: Duration(seconds: 2),
              // shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(remove);
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .update({'liked-monuments': FieldValue.arrayRemove(data)});
          } on RangeError catch (e) {
            print(e);
            Navigator.of(context).pop();
          }
        }
      }
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
