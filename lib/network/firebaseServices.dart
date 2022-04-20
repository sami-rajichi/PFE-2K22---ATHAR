import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<String> getFileUrl(String fileName) async {
    return await firebaseStorage.ref('/Models/$fileName').getDownloadURL();
  }
}
