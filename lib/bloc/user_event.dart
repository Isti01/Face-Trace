import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserEvent {}

class NewUserEvent extends UserEvent {
  final FirebaseUser newUser;

  NewUserEvent(this.newUser);
}

class UserDataUpdated extends UserEvent {
  final DocumentSnapshot userData;

  UserDataUpdated(this.userData);
}
