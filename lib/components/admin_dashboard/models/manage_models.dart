import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';
import 'package:monumento/components/admin_dashboard/admin_navigator.dart';
import 'package:monumento/components/admin_dashboard/monuments/add_monument.dart';
import 'package:monumento/components/admin_dashboard/models/admin_ar_models.dart';
import 'package:monumento/components/admin_dashboard/requests/consult_rquest.dart';
import 'package:monumento/components/admin_dashboard/requests/requests_homepage.dart';
import 'package:monumento/components/ar/ar_models.dart';
import 'package:monumento/constants/colors.dart';
import 'package:monumento/network/firebaseServices.dart';
import 'package:monumento/shared/components/neumorphic_image.dart';

class ManageModels extends StatefulWidget {

  const ManageModels({Key? key,}) : super(key: key);

  @override
  State<ManageModels> createState() => _ManageModelsState();
}

class _ManageModelsState extends State<ManageModels> {
  FirebaseServices firebaseServices = new FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ar_models')
            .doc('ar_models')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var d = snapshot.data as DocumentSnapshot;
            List models = d['ar_models'];
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Manage 3D Models',
                  style: TextStyle(color: AppColors.bigTextColor),
                ),
                centerTitle: true,
                leading: BackButton(
                  color: AppColors.bigTextColor,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminNavigator()));
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
                                image: AssetImage('assets/img/cubes.png'),
                                fit: BoxFit.fitHeight,
                                height: 150,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    _request(models)
                  ],
                ),
              ),
              backgroundColor: AppColors.backgroundColor,
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget _request(List models) {
    return Container(
      height: MediaQuery.of(context).size.height - 340,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: models.length,
          itemBuilder: (context, index) {
            final item = models[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Dismissible(
                key: UniqueKey(),
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
                onDismissed: (DismissDirection direction) {
                  switch (direction) {
                    case DismissDirection.startToEnd:
                      showDialog(
                          context: context,
                          builder: (context) => saveAlert(
                                models[index]['name'],
                                models[index]['image'],
                                models[index]['models'],
                              ));
                      break;
                    case DismissDirection.endToStart:
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminARModels(
                          monumentName: models[index]['name'], 
                          models: models[index]['models'])));
                      break;
                    default:
                      print('Invalid Option !!');
                  }
                },
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AdminARModels(
                          monumentName: models[index]['name'], 
                          models: models[index]['models'])));
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
                        backgroundImage: AssetImage(models[index]['image'])
                      ),
                      title: Text(models[index]['name']),
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
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => saveAlert(
                                            models[index]['name'],
                                            models[index]['image'],
                                            models[index]['models'],
                                          ));
                                },
                                icon: Icon(
                                  Icons.delete_sweep,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  openDilog(
                                    models[index]['image'], 
                                    models[index]['name'], 
                                    models[index]['models']);
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
                      minLeadingWidth: 46,
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future delete(BuildContext context, String name, String img,
      String model) async {
    try {
      var data = [
        {
          'name': name,
          'models': model,
          'image': img
        }
      ];
      await FirebaseFirestore.instance
          .collection('ar_models')
          .doc('ar_models')
          .update({'ar_models': FieldValue.arrayRemove(data)});

      final snackBar = SnackBar(
        content: RichText(
            text: TextSpan(children: [
          const TextSpan(
              text: 'A model has been deleted successfully\n\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          TextSpan(
              text: 'A model of $name has been deleted',
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
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 4),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget saveAlert(String img, String name, String model) {
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
                      'Delete Model',
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
                      'Would you really want to delete this model?',
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
                                  builder: (context) => ManageModels()));
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
                            delete(context, img, name, model);
                            Navigator.of(context).pop();
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
  
  openDilog(String image, String name, String model){
    return showDialog(
      context: context, 
      builder: (context){
        return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 340,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 65, 10, 10),
              child: Container()
            ),
          ),
          Positioned(
            top: -65,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40,
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                ),
            )
          ),
        ],
      )
    );
      }
    );
  }
}
