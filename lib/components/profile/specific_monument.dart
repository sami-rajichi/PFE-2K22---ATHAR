import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/components/categories/buildCategoryPage.dart';
import 'package:monumento/models/monuments.dart';
import 'package:monumento/network/firebaseServices.dart';
import 'package:monumento/shared/components/getAvatar.dart';

class SpecificMonument extends StatefulWidget {
  final int? index;
  final String? region;
  final bool? specificMonument;

  SpecificMonument({
    Key? key,
    required this.index,
    required this.region,
    required this.specificMonument,
  }) : super(key: key);

  @override
  State<SpecificMonument> createState() => _SpecificMonumentState();
}

class _SpecificMonumentState extends State<SpecificMonument> {
  FirebaseServices firebaseServices = new FirebaseServices();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var uid = auth.currentUser!.uid;
    return showSpecificMonument(uid, auth.currentUser!);
  }

  Widget showSpecificMonument(String uid, User user) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong!');
          } else if (snapshot.hasData) {
            var d = snapshot.data as DocumentSnapshot;
            var likedMonuments = d['liked-monuments'];
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: BackButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  color: Colors.black,
                ),
                actions: [
                  GetAvatar(
                    img: d['image'],
                    loggedIn: true,
                    name: d['name'],
                    email: d['email'],
                    gender: d['gender'],
                    pass: d['password'],
                  )
                ],
              ),
              body: StreamBuilder<List<Monument>>(
                  stream: firebaseServices.getMonuments(widget.region!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong! ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final monuments = snapshot.data!;
                      final count = monuments.length;
                      return monument(
                          likedMonuments[widget.index]['name'], monuments);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget monument(String name, List<Monument> monuments) {
    for (Monument e in monuments) {
      if (e.name == name) {
        return CategoryPage(
          fromListView: true,
          name: e.name,
          image: e.image,
          location: e.location,
          region: e.region,
          info: e.info,
          url: e.url,
          color: Colors.grey[400]!.withOpacity(0.2),
        );
      }
    }
    return Center(
      child: Lottie.asset(
        'assets/animations/error.json',
        height: 400,
        width: 400,
        repeat: true,
      ),
    );
  }
}
