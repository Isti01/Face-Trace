import 'dart:io';

import 'package:face_app/bloc/firebase/firestore_queries.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as path;

Future<String> uploadPhoto(
  FirebaseUser user,
  String photoPath,
  String basePath,
) async {
  final imageFile = File(photoPath);
  final imageReference = storage.ref().child(
        '$basePath/${path.basename(imageFile.path)}',
      );
  await imageReference.putFile(imageFile).onComplete;

  return await imageReference.getDownloadURL() as String;
}
