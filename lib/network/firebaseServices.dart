import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monumento/models/monuments.dart';

class FirebaseServices {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  CollectionReference firebaseFirestore = FirebaseFirestore.instance.collection('north_monuments');
  
  Stream<List<Monument>> getMonuments(String region) {
    switch (region){
      case 'north' : firebaseFirestore = FirebaseFirestore.instance
      .collection('north_monuments'); break;
      case 'center' : firebaseFirestore = FirebaseFirestore.instance
      .collection('central_monuments'); break;
      case 'sud' : firebaseFirestore = FirebaseFirestore.instance
      .collection('sud_monuments'); break;
    }
    return firebaseFirestore.snapshots().map((snapshot) => 
                 snapshot.docs.map((doc) => 
                 Monument.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  Future<String> getFileUrl(String fileName) async {
    return await firebaseStorage.ref('/Models/$fileName').getDownloadURL();
  }

  Future signIn(
    TextEditingController email, 
    TextEditingController password, 
    BuildContext context
    ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.text.trim(), 
      password: password.text.trim()
      );
    } on FirebaseAuthException catch (e){
      final snackBar = SnackBar(
        content: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Login Failed\n\n',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                )
              ),
              TextSpan(
                text: '['+e.code.toString()+']:'+e.toString().substring(e.toString().lastIndexOf(']')+1),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white
                )
              ),
            ]
          )),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 4),
        // shape: StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
