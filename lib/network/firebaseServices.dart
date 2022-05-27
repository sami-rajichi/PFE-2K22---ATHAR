import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:monumento/models/monuments.dart';
import 'package:monumento/models/reviews.dart';

class FirebaseServices {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  CollectionReference firebaseFirestore = FirebaseFirestore.instance.collection('north_monuments');
  CollectionReference reviewsFirestore = FirebaseFirestore.instance.collection('users_reviews');
  CollectionReference userFirestore = FirebaseFirestore.instance.collection('users');

  Stream<DocumentSnapshot> getUser(String? id) {
    Stream<DocumentSnapshot> doc = userFirestore.doc(id).snapshots();
    return doc;
  }

  Stream<List<Monument>> getMonuments(String region) {
    switch (region){
      case 'north' : firebaseFirestore = FirebaseFirestore.instance
      .collection('north_monuments'); break;
      case 'central' : firebaseFirestore = FirebaseFirestore.instance
      .collection('central_monuments'); break;
      case 'sud' : firebaseFirestore = FirebaseFirestore.instance
      .collection('sud_monuments'); break;
    }
    return firebaseFirestore.snapshots().map((snapshot) => 
                 snapshot.docs.map((doc) => 
                 Monument.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  Stream<List<Review>> getReviews() {
    return reviewsFirestore.snapshots().map((snapshot) => 
                 snapshot.docs.map((doc) => 
                 Review.fromJson(doc.data() as Map<String, dynamic>)).toList());
  }

  Future<String> getFileUrl(String fileName) async {
    return await firebaseStorage.ref('/Models/$fileName').getDownloadURL();
  }
}
