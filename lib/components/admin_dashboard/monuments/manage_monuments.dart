import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/components/admin_dashboard/admin_navigator.dart';
import 'package:monumento/components/admin_dashboard/consult_account.dart';
import 'package:monumento/components/admin_dashboard/create_account.dart';
import 'package:monumento/components/admin_dashboard/monuments/add_monument.dart';
import 'package:monumento/components/admin_dashboard/monuments/consult_monument.dart';
import 'package:monumento/components/admin_dashboard/monuments/monument_page.dart';
import 'package:monumento/components/admin_dashboard/monuments/monuments_homepage.dart';
import 'package:monumento/components/admin_dashboard/monuments/update_monument.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/models/monuments.dart';
import 'package:monumento/models/users.dart';
import 'package:monumento/network/firebaseServices.dart';
import 'package:monumento/shared/components/neumorphic_image.dart';

class ManageMonuments extends StatefulWidget {
  final String? region;
  const ManageMonuments({Key? key, required this.region}) : super(key: key);

  @override
  State<ManageMonuments> createState() => _ManageMonumentsState();
}

class _ManageMonumentsState extends State<ManageMonuments> {
  FirebaseServices firebaseServices = new FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Monument>>(
        stream: firebaseServices.getMonuments(widget.region!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final monuments = snapshot.data!;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Monuments',
                  style: TextStyle(color: AppColors.bigTextColor),
                ),
                centerTitle: true,
                leading: BackButton(
                  color: AppColors.bigTextColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MonumentsHomepage()));
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
                          neumorphicImage(
                              color: Colors.white,
                              image: Image(
                                image: AssetImage('assets/img/ruins.png'),
                                fit: BoxFit.fitHeight,
                                height: 150,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    _monuments(monuments)
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: AppColors.mainColor,
                onPressed: () {
                  openDilog();
                },
              ),
              backgroundColor: AppColors.backgroundColor,
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _monuments(List<Monument> monument) {
    return Container(
      height: MediaQuery.of(context).size.height - 340,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: monument.length,
          itemBuilder: (context, index) {
            final item = monument[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Dismissible(
                key: UniqueKey(),
                secondaryBackground: const Card(
                  color: Colors.green,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.edit_note,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                background: const Card(
                  color: Colors.red,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.delete_sweep,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                onDismissed: (DismissDirection direction) async {
                  switch (direction) {
                    case DismissDirection.endToStart:
                      String model = await getModel(monument[index].name!);
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return UpdateMonument(
                              name: monument[index].name,
                              image: monument[index].image,
                              location: monument[index].location,
                              region: monument[index].region,
                              info: monument[index].info,
                              url: monument[index].url,
                              model: model,
                            );
                          });
                      break;
                    case DismissDirection.startToEnd:
                      String model = await getModel(monument[index].name!);
                      showDialog(
                          context: context,
                          builder: (context) => saveAlert(
                                monument[index].name!,
                                model,
                                monument[index].image!,
                              ));
                      break;
                    default:
                      print('Invalid Option !!');
                  }
                },
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConsultMonument(
                              name: monument[index].name,
                              image: monument[index].image,
                              location: monument[index].location,
                              region: monument[index].region,
                              info: monument[index].info,
                              url: monument[index].url,
                            )));
                  },
                  child: Material(
                    elevation: 8,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    child: ListTile(
                      key: ObjectKey(item),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: getImage(monument[index].image!),
                      ),
                      title: Text(monument[index].name!),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          monument[index].location!,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      tileColor: Colors.white,
                      trailing: Transform.translate(
                        offset: Offset(8, 0),
                        child: SizedBox(
                          width: 96,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () async {
                                  String model =
                                      await getModel(monument[index].name!);
                                  showDialog(
                                      context: context,
                                      builder: (context) => saveAlert(
                                            monument[index].name!,
                                            model,
                                            monument[index].image!,
                                          ));
                                },
                                icon: Icon(
                                  Icons.delete_sweep,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  String model =
                                      await getModel(monument[index].name!);
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return UpdateMonument(
                                          name: monument[index].name,
                                          image: monument[index].image,
                                          location: monument[index].location,
                                          region: monument[index].region,
                                          info: monument[index].info,
                                          url: monument[index].url,
                                          model: model,
                                        );
                                      });
                                },
                                icon: Icon(
                                  Icons.edit_note,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      minLeadingWidth: 60,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<String> getModel(String name) async {
    final doc = await FirebaseFirestore.instance
        .collection('ar_models')
        .doc('ar_models')
        .get();
    final data = doc.data();
    List models = doc['ar_models'];
    String model = '';
    for (var i = 0; i < models.length; i++) {
      if (models[i]['name'] == name) {
        model = models[i]['models'];
        break;
      }
    }
    return model;
  }

  Future deleteModel(String name, String model, String image) async {
    var data = [
      {
        'image': image,
        'models': model,
        'name': name,
      }
    ];
    await FirebaseFirestore.instance
        .collection('ar_models')
        .doc('ar_models')
        .update({'ar_models': FieldValue.arrayRemove(data)});
  }

  ImageProvider getImage(String image) {
    if (image == null) {
      return AssetImage('assets/img/avatar.png');
    } else if (image.startsWith('assets/')) {
      return AssetImage(image);
    } else {
      return NetworkImage(image);
    }
  }

  openDilog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AddMonument(
            region: widget.region,
          );
        });
  }

  Widget saveAlert(String name, String model, String image) {
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
                      'Delete Monument',
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
                      'Would you really want to delete $name?',
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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ManageMonuments(
                                        region: widget.region,
                                      )));
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
                          onPressed: () async {
                            deleteModel(name, model, image);
                            await FirebaseFirestore.instance
                                .collection(
                                    widget.region!.trim() + '_monuments')
                                .doc(name.trim().replaceAll(' ', ''))
                                .delete();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ManageMonuments(
                                      region: widget.region,
                                    )));
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
}
