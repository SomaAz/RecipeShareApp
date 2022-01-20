import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static final _firebaseStorage = FirebaseStorage.instance;
  Future<String> uploadImageToStorage(File image, String userPrimaryKey) async {
    try {
      return (await _firebaseStorage
              .ref()
              .child("usersImages")
              .child(userPrimaryKey)
              .putFile(image))
          .ref
          .getDownloadURL();
    } catch (e) {
      return Future.error(e);
    }
  }
}
