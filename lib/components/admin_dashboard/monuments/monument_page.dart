import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:monumento/components/admin_dashboard/monuments/manage_monuments.dart';
import 'package:monumento/components/admin_dashboard/monuments/monuments_homepage.dart';
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

class MonumentPage extends StatefulWidget {
  final String? name;
  final String? info;
  final String? location;
  final String? image;
  final String? region;
  final Color? color;
  final Color? backgroundColor;
  final String? url;
  final bool? fromListView;

  MonumentPage({
    Key? key,
    this.name,
    this.location,
    this.image,
    this.region,
    this.color = Colors.white,
    this.backgroundColor = Colors.white,
    this.url,
    this.info,
    this.fromListView,
  }) : super(key: key);

  @override
  State<MonumentPage> createState() => _MonumentPageState();
}

class _MonumentPageState extends State<MonumentPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return screen();
  }

  Widget screen() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: BackButton(
          color: AppColors.bigTextColor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MonumentsHomepage()));
          },
        ),
      ),
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
                        image: getImage(widget.image!),
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

  ImageProvider getImage(String image) {
    if (image == null) {
      return AssetImage('assets/img/avatar.png');
    } else if (image.startsWith('assets/')) {
      return AssetImage(image);
    } else if (image.startsWith('http')) {
      return NetworkImage(image);
    } else {
      return FileImage(File(image));
    }
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
                      fontSize: 12,
                      letterSpacing: 2.2,
                      color: AppColors.mainColor),
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    ARModels(monumentName: widget.name, models: model)));
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
        .doc('ar_models')
        .get();
    final data = doc.data();
    List models = doc['ar_models'];
    String model = '';
    for (var i = 0; i < models.length; i++) {
      if (models[i]['name'] == widget.name) {
        model = models[i]['models'];
        break;
      }
    }
    return model;
  }
}
